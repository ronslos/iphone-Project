//
//  OpenCVClientViewController.h
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

#import <UIKit/UIKit.h>


@interface CalibrationViewController : UIViewController
{
    cv::VideoCapture *_videoCapture;
    cv::Mat _lastFrame;
    cv::vector<cv::vector<cv::Point2f> > _imagePoints[2];
    cv::vector<cv::vector<cv::Point3f> > _objectPoints;
    cv::Size _boardSize;
    int _imageCount;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;

- (IBAction)capture:(id)sender;
- (IBAction)sliderChanged:(id)sender;
- (IBAction)Calibrate:(id)sender;

@end
