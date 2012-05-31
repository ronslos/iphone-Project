 //
//  OpenCVClientViewController.m
//  OpenCVClient
//
//  Created by Robin Summerhill on 02/09/2011.
//  Copyright 2011 Aptogo Limited. All rights reserved.
//
//  Permission is given to use this source code file without charge in any
//  project, commercial or otherwise, entirely at your risk, with the condition
//  that any redistribution (in part or whole) of source code must retain
//  this copyright and permission notice. Attribution in compiled projects is
//  appreciated but not required.
//

// UIImage extensions for converting between UIImage and cv::Mat

#define MAX_CALIBRATION_IMAGES 20

#import "CalibrationViewClontroller.h"
#import "UIImage+OpenCV.h"
#include "File.h"

@interface CalibrationViewController()
- (UIImage*)findCorners;
@end

@implementation CalibrationViewController

@synthesize imageView = _imageView;
@synthesize timeLabel = _timeLabel;
@synthesize captureBtn = _captureBtn;

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
#endif
    _notCapturing = YES;
     _boardSize = cv::Size(9,6);
    _imageCount = 0;
    _otherImageCount = 0;
    _imagePoints[0].resize(MAX_CALIBRATION_IMAGES);
    _imagePoints[1].resize(MAX_CALIBRATION_IMAGES);
    _sessionManager = [SessionManager instance];
    [[_sessionManager mySession ] setDataReceiveHandler:self withContext:nil];
    
    [self showCaptureOnScreen];
    
    // Load a test image and demonstrate conversion between UIImage and cv::Mat
    //UIImage *testImage = [UIImage imageNamed:@"left01.jpg"];
    
    //_lastFrame = [testImage CVMat];
}

-(void)showCaptureOnScreen
{
    sleep(2);
    dispatch_queue_t myQueue = dispatch_queue_create("my op thread", NULL);
    
    dispatch_async(myQueue, ^{
        double t;
        while(_notCapturing){
            t = (double)cv::getTickCount();
            if (_videoCapture && _videoCapture->grab())
            { 
                (*_videoCapture) >> _lastFrame;
                //[self processFrame];
                t = 1000 * ((double)cv::getTickCount() - t) / cv::getTickFrequency();
                dispatch_sync(dispatch_get_main_queue(), ^{
                    self.timeLabel.text = [NSString stringWithFormat:@"%.1fms", t];
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

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Called when the user taps the Capture button. Grab a frame and process it
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
        _captureBtn.enabled = NO;
        dispatch_queue_t myQueue = dispatch_queue_create("my op thread", NULL);
        dispatch_async(myQueue, ^{
            UIImage* corners = [self findCorners];
            dispatch_sync(dispatch_get_main_queue(), ^{
                _captureBtn.enabled = YES;
                self.imageView.image = corners;
            });
            _notCapturing = YES;
            [self showCaptureOnScreen];
        });
        dispatch_release(myQueue);
    }
    else
    {
        NSLog(@"Failed to grab frame");        
    }
}

// Perform image processing on the last captured frame and display the results
- (UIImage *)findCorners
{
    cv::Mat grayFrame, cornersImg;
    // Convert captured frame to grayscale
    cv::cvtColor(_lastFrame, grayFrame, CV_RGB2GRAY);
    _imageSize = grayFrame.size();

    if(StereoCalib(grayFrame ,_boardSize,_imagePoints,_imageCount,cornersImg))
    {
        NSData* data = [self dataFromVector: &_imagePoints[0][_imageCount]];
        [_sessionManager sendDataToPeers:NULL WithData:data];
        _imageCount++;
    }
    UIImage * corners = ([UIImage imageWithCVMat:cornersImg]);
    
    
    return  corners;

}

- (IBAction)Calibrate:(id)sender
{
    if( _imageCount != _otherImageCount)
    {
        _imageCount = 0;
        _otherImageCount =0;
        return;
        
    }
    _objectPoints.resize(_imageCount);
    double rms =  calibrateCameras( _boardSize,_imagePoints, _objectPoints, _imageCount , _imageSize);
}

-(NSData*) dataFromVector:(cv::vector<cv::Point2f>*) vector
{
    NSUInteger size = vector->size();
    NSMutableArray* array = [[NSMutableArray alloc] initWithCapacity:2*size];
    cv::vector<cv::Point2f>::iterator iter;
    for (iter = vector->begin() ; iter<vector->end() ; iter++)
    {
        [array addObject: [NSNumber numberWithFloat:iter->x]];
        [array addObject: [NSNumber numberWithFloat:iter->y]];
        NSLog(@"sent: %f %f",iter->x,iter->y);
    }
    
    NSData* data = [NSKeyedArchiver archivedDataWithRootObject:array];
    return data;
}

-(void) fillVectorFromData: (NSData *) data :(cv::vector<cv::Point2f>*) vector
{
    NSMutableArray* array = [NSKeyedUnarchiver unarchiveObjectWithData:data];
    vector->resize((int)[array count]/2);
    cv::vector<cv::Point2f>::iterator iter = vector->begin();
    NSEnumerator* enumerator = [array objectEnumerator];
    id object;
    while (object = [enumerator nextObject]) {
        //cv::Point2f* point = new cv::Point2f;
        iter->x = [object floatValue];
        object = [enumerator nextObject];
        iter->y = [object floatValue];
        NSLog(@"received: %f %f",iter->x,iter->y);
        iter++;
    }
    NSLog(@"%lu %lu",_imagePoints[0][_imageCount-1].size(),_imagePoints[1][_imageCount-1].size());
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
    else
    {
        [self fillVectorFromData:data :&(_imagePoints[1][_otherImageCount]) ];
        _otherImageCount ++ ; 
    }
}
@end
