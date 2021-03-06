#import <UIKit/UIKit.h>
#import "SessionManager.h"
#import <AVFoundation/AVCaptureDevice.h>


@interface CalibrationViewController : UIViewController <GKPeerPickerControllerDelegate>
{
    cv::VideoCapture *_videoCapture;
    cv::Mat _lastFrame;
    cv::vector<cv::vector<cv::Point2f> > _imagePoints[2];
    cv::vector<cv::vector<cv::Point3f> > _objectPoints;
    cv::Size _boardSize;
    cv::Size _imageSize;
    float _squareSize;
    int _imageCount;
    int _otherImageCount;
    bool _notCapturing;
    SessionManager* _sessionManager;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *captureBtn;
@property (retain, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@property (retain, nonatomic) IBOutlet UIButton *calibrationButton;

- (IBAction)capturePressed:(id)sender;
- (void) capture;
- (IBAction)Calibrate:(id)sender;
- (void) showCaptureOnScreen;


@end
