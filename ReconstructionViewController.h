#import <UIKit/UIKit.h>
#import "SessionManager.h"
#import <AVFoundation/AVCaptureDevice.h>
// omer - add this class for the reconstruction view controller

@interface ReconstructionViewController : UIViewController <GKPeerPickerControllerDelegate , UIAlertViewDelegate>
{
    cv::VideoCapture *_videoCapture;
    cv::Size _imageSize;
    cv::Mat _lastFrame;
    cv::Mat _secondImg;
    cv::Mat _depthImg;
    bool _notCapturing;
    bool _chunksReceived;
    bool _pause;
    int _chunkCount;
    int _totalChunks;
    NSMutableData* _imgData;
    SessionManager* _sessionManager;
    cv::Mat _map11, _map12, _map21 ,_map22 ,_Q;
    cv::Rect _roi1 , _roi2;
}

@property (nonatomic, retain) IBOutlet UIImageView *imageView;
@property (nonatomic, retain) IBOutlet UIButton *captureBtn;

- (IBAction)capturePressed:(id)sender;
- (void) capture;


@end
