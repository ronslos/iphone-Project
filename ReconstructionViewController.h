#import <UIKit/UIKit.h>
#import "SessionManager.h"
#import <AVFoundation/AVCaptureDevice.h>
// omer - add this class for the reconstruction view controller

@interface ReconstructionViewController : UIViewController <GKPeerPickerControllerDelegate>
{
    cv::VideoCapture *_videoCapture;
    cv::Size _imageSize;
    cv::Mat _lastFrame;
    cv::Mat _secondImg;
    cv::Mat _depthImg;
    bool _notCapturing;
    bool _chunksReceived;
    int _chunkCount;
    int _totalChunks;
    NSMutableData* _imgData;
    SessionManager* _sessionManager;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *captureBtn;

- (IBAction)capturePressed:(id)sender;
- (void) capture;


@end
