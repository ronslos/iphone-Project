//
//  ReconstructionViewController.m
//  3d_visioin
//
//  Created by Ron Slossberg on 8/9/12.
//  Copyright (c) 2012 ronslos@gmail.com. All rights reserved.
//

#import "ReconstructionViewController.h"
#import "UIImage+OpenCV.h"
#include "File.h"

static int TEN_K = 51200/8;

@interface ReconstructionViewController ()

@end

@implementation ReconstructionViewController
@synthesize imageView = _imageView;
@synthesize captureBtn = _captureBtn;

// omer - implementation of reconstruction view controller
// important - i could not get the screen to show the disparity map and then return to the camera.
// right now you get the camera in the start and then after you capture you get the disparity map and it stays.
// try to solve this if you can
- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Initialise video capture - only supported on iOS device NOT simulator
#if TARGET_IPHONE_SIMULATOR
    NSLog(@"Video capture is not supported in the simulator");
#else
    _videoCapture = new cv::VideoCapture;
    if (!_videoCapture->open(CV_CAP_AVFOUNDATION))
    {
        NSLog(@"Failed to open video camera");
    }
    else {
        _videoCapture->set(CV_CAP_PROP_IOS_DEVICE_EXPOSURE, AVCaptureExposureModeContinuousAutoExposure);
        _videoCapture->set(CV_CAP_PROP_IOS_DEVICE_WHITEBALANCE, AVCaptureWhiteBalanceModeAutoWhiteBalance );
        _videoCapture->set(CV_CAP_PROP_IOS_DEVICE_FOCUS, AVCaptureFocusModeLocked );
    }
#endif
    _videoCapture -> grab();
    (*_videoCapture) >> _lastFrame;
    _imageSize = _lastFrame.size();
    _notCapturing = YES;
    _chunksReceived = YES;
    _chunkCount = 0;
    _totalChunks = 0;
    _secondImg =cv::Mat(_imageSize,CV_8UC3);
    _sessionManager = [SessionManager instance];
    [[_sessionManager mySession ] setDataReceiveHandler:self withContext:nil];
    
    [self showCaptureOnScreen];
    
}

-(void)showCaptureOnScreen
{
    sleep(2);
    dispatch_queue_t myQueue = dispatch_queue_create("my op thread", NULL);
    
    dispatch_async(myQueue, ^{
        while(_notCapturing){
            if (_videoCapture && _videoCapture->grab())
            {
                (*_videoCapture) >> _lastFrame;
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.imageView.image = [UIImage imageWithCVMat:_lastFrame];
                });
            }
            else
            {
                NSLog(@"Failed to grab frame");
            }
        }
    });
    dispatch_release(myQueue);
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;
    
    delete _videoCapture;
    _videoCapture = nil;
    _captureBtn = nil;
}

- (IBAction)capturePressed:(id)sender
{
    [_sessionManager sendClick: self];
    [self capture];
}

-(void) capture
{
    if (_videoCapture && _videoCapture->grab())
    {
        _notCapturing = NO;
        (*_videoCapture) >> _lastFrame;
        cv::Mat grayFrame;
        cv::cvtColor(_lastFrame, grayFrame, CV_RGB2GRAY);
        
        // omer - send captured image in packages
        
        NSData* data = [self dataFromImage:&grayFrame];
        NSUInteger chunkCount = (NSUInteger)(data.length / TEN_K) + (data.length % TEN_K== 0 ? 0:1) ;
        NSString *chunkCountStr = [NSString stringWithFormat:@"%d",chunkCount];
        NSData* chunkCountData = [chunkCountStr dataUsingEncoding: NSASCIIStringEncoding];
        [_sessionManager sendDataToPeers:NULL WithData:chunkCountData];
        NSData *dataToSend;
        NSRange range = NSMakeRange(0, 0);
        for(NSUInteger i=0;i<data.length;i+=TEN_K){
            range = NSMakeRange(i, TEN_K);
            dataToSend = [data subdataWithRange:range];
            [_sessionManager sendDataToPeers:NULL WithData:dataToSend];
        }
        NSUInteger remainder = (data.length % TEN_K);
        if (remainder != 0){
            range = NSMakeRange(data.length - remainder,remainder);
            dataToSend = [data subdataWithRange:range];
            [_sessionManager sendDataToPeers:NULL WithData:dataToSend];
        }
        
        // omer - end of image sending code

        [self.captureBtn setEnabled:NO];
        dispatch_queue_t myQueue = dispatch_queue_create("my op thread", NULL);
        dispatch_async(myQueue, ^{
                         
            dispatch_sync(dispatch_get_main_queue(), ^{
                [self.captureBtn setEnabled:YES];
                
            });
        });
        dispatch_release(myQueue);
    }
    else
    {
        NSLog(@"Failed to grab frame");
    }
}

-(NSMutableData*) dataFromImage:(cv::Mat*) image
{
    int matRows = image->rows;
    int matCols = image->cols;
    NSMutableData* data = [[NSMutableData alloc]init];
    unsigned char *pix;
    for (int i = 0; i < matRows; i++)
    {
        for (int j = 0; j < matCols; j++ )
        {
            pix = &image->data[i * matCols + j ];
            [data appendBytes:(void*)pix length:1];
        }
    }
    return data;
}

-(void) imageFromData: (NSData *) data withSize:(cv::Size) size: (cv::Mat*) img {
    unsigned char *pix=NULL , *bytes;
    bytes = (unsigned char*)[data bytes];
    for (int i = 0; i < size.height; i++)
    {
        for (int j = 0; j < size.width; j ++)
        {
            
            pix  = &bytes[i * size.width + j ];
            img->at<unsigned char>(i , 3*j+1 ) = *pix;
            img->at<unsigned char>(i , 3*j+2 ) = *pix;
            img->at<unsigned char>(i , 3*j ) = *pix;

           // NSLog(@"%d\n" ,i * size.width*3 + j);
        }
    }
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}
#pragma mark -
#pragma mark GKPeerPickerControllerDelegate

- (void)receiveData:(NSData *)data fromPeer:(NSString *)peer inSession: (GKSession *)session context:(void *)context
{
    NSString *whatDidIget = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
    if(![whatDidIget caseInsensitiveCompare:@"capture"])
    {
        [self capture];
    }
    else if (_chunksReceived == YES)
    {
        // omer - handle the recieving of image data and rebuild image
        NSString* chunkCountStr = [[NSString alloc] initWithData:data encoding:NSASCIIStringEncoding];
        _totalChunks = [chunkCountStr intValue];
        _chunksReceived = NO;
        _imgData = [[NSMutableData alloc]init];
    }
    else
    {
        [_imgData appendData:data];
        _chunkCount++;
        NSLog(@"%d" , _chunkCount);
        if(_chunkCount == _totalChunks)
        {
            _chunksReceived = YES ;
            _chunkCount = 0;
            [self imageFromData:_imgData withSize:_imageSize :&_secondImg];
            cv::Mat gray1,gray2;
            cv::cvtColor(_lastFrame, gray1, CV_RGB2GRAY);
            cv::cvtColor(_secondImg, gray2, CV_RGB2GRAY);
            reconstruct(_imageSize, &gray1, &gray2, &(_depthImg));
            _notCapturing = NO;
            self.imageView.image = [UIImage imageWithCVMat:_depthImg];
            
        }
    }
}
- (void)dealloc {
    [_captureBtn release];
    [super dealloc];
}

@end
