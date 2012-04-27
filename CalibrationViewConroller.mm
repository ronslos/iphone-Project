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

#import "CalibrationViewClontroller.h"
#import "UIImage+OpenCV.h"
#include "File.h"

@interface CalibrationViewController()
- (void)processFrame;
@end

@implementation CalibrationViewController

@synthesize imageView = _imageView;

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
     _boardSize = cv::Size(6,9);
    _imageCount = 1;

    
    // Load a test image and demonstrate conversion between UIImage and cv::Mat
    //UIImage *testImage = [UIImage imageNamed:@"left01.jpg"];
    
    //_lastFrame = [testImage CVMat];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.imageView = nil;

    delete _videoCapture;
    _videoCapture = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    // Return YES for supported orientations
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

// Called when the user taps the Capture button. Grab a frame and process it
- (IBAction)capture:(id)sender
{
    if (_videoCapture && _videoCapture->grab())
    { 
        (*_videoCapture) >> _lastFrame;
        [self processFrame];

    }
    else
    {
        NSLog(@"Failed to grab frame");        
    }
}

// Perform image processing on the last captured frame and display the results
- (void)processFrame
{
    _imagePoints[0].resize(_imageCount);
    _imagePoints[1].resize(_imageCount);

    cv::Mat grayFrame, cornersImg;
    // Convert captured frame to grayscale
    cv::cvtColor(_lastFrame, grayFrame, CV_RGB2GRAY);

    if(StereoCalib(grayFrame ,_boardSize,_imagePoints,_imageCount,cornersImg))
    {
        _imageCount++;
    }
    self.imageView.image = [UIImage imageWithCVMat:cornersImg];    
    // Display result 

}

- (IBAction)Calibrate:(id)sender
{
    _objectPoints.resize(_imageCount);
    double rms =  calibrateCameras( _boardSize,_imagePoints, _objectPoints, _imageCount);
}

// Called when the user changes either of the threshold sliders
- (IBAction)sliderChanged:(id)sender
{
    //[self processFrame];
}

@end
