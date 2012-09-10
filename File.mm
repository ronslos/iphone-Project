//
//  File.c
//  OpenCVClient
//
//  Created by Ron Slossberg on 4/24/12.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//

#include "File.h"

using namespace std;
using namespace cv;

bool StereoCalib(cv::Mat img , cv::Size boardSize,cv::vector<cv::vector<cv::Point2f> >(&imagePoints)[2],int numImage, cv::Mat& cornersImg)
{
    bool displayCorners = true;
    const int maxScale = 2;
   
    // ARRAY AND VECTOR STORAGE:
    
            bool found = false;
            vector<Point2f>& corners = imagePoints[0][numImage];
            for( int scale = 1; scale <= maxScale; scale++ )
            {
                Mat timg;
                if( scale == 1 )
                    timg = img;
                else

                    resize(img, timg, cv::Size(), scale, scale);
                found = findChessboardCorners(timg, boardSize, corners, 
                                              CV_CALIB_CB_ADAPTIVE_THRESH | CV_CALIB_CB_NORMALIZE_IMAGE);
                if( found )
                {
                    if( scale > 1 )
                    {
                        Mat cornersMat(corners);
                        cornersMat *= 1./scale;
                    }
                    break;
                }
            }
            if( displayCorners )
            {
                Mat cimg;
                cvtColor(img, cimg, CV_GRAY2BGR);
                drawChessboardCorners(cimg, boardSize, corners, found);
                double sf = 640./MAX(img.rows, img.cols);
                resize(cimg, cornersImg, cv::Size(), sf, sf);
                //imshow("corners", cimg1);
                //char c = (char)waitKey(500);
                //if( c == 27 || c == 'q' || c == 'Q' ) //Allow ESC to quit
                    //exit(-1);
            }
            if( !found )
                return false;
            cornerSubPix(img, corners, cv::Size(11,11), cv::Size(-1,-1),TermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS,30, 0.01));
    return true;

}

double calibrateCameras( cv::Size boardSize,cv::vector<cv::vector<cv::Point2f> >(& imagePoints)[2], cv::vector<cv::vector<cv::Point3f> >& objectPoints, int numImage , cv::Size imageSize , const float squareSize)
{
    
    imagePoints[0].resize(numImage);
    imagePoints[1].resize(numImage);
    objectPoints.resize(numImage);
    
    //const float squareSize = 1.f;  // Set this to your actual square size
    int i , j , k;

    for( i = 0; i < numImage; i++ )
    {
        for( j = 0; j < boardSize.height; j++ )
            for( k = 0; k < boardSize.width; k++ )
                objectPoints[i].push_back(Point3f(j*squareSize, k*squareSize, 0));
    }

    // omer - note changes in deffinition of distcoeffs matrix
    Mat cameraMatrix[2], distCoeffs[2];
    cameraMatrix[0] = Mat::eye(3, 3, CV_64F);
    cameraMatrix[1] = Mat::eye(3, 3, CV_64F);
    distCoeffs[0] = Mat::zeros(1, 5, CV_64F);
    distCoeffs[1] = Mat::zeros(1, 5, CV_64F);

    
    Mat R, T, E, F , TArr , RArr;
    // omer - note change in flags for calibration function. please use these flags instead of previous.
    double rms = stereoCalibrate(objectPoints, imagePoints[0], imagePoints[1],
                                            cameraMatrix[0], distCoeffs[0],
                                            cameraMatrix[1], distCoeffs[1],
                                            imageSize, R, T, E, F,
                                            TermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS, 100, 1e-5),
                                            CV_CALIB_FIX_ASPECT_RATIO +
                                            CV_CALIB_ZERO_TANGENT_DIST +
                                            CV_CALIB_SAME_FOCAL_LENGTH );
    
    
    
    [manageCVMat storeCVMat:cameraMatrix[0] withKey:@"cameraMatrix1"];
    [manageCVMat storeCVMat:cameraMatrix[1] withKey:@"cameraMatrix2"];
    [manageCVMat storeCVMat:distCoeffs[0] withKey:@"distCoeffs1"];
    [manageCVMat storeCVMat:distCoeffs[1] withKey:@"distCoeffs2"];
    [manageCVMat storeCVMat:R withKey:@"Rarray"];
    [manageCVMat storeCVMat:T withKey:@"Tarray"];
    [manageCVMat storeCVMat:F withKey:@"Farray"];
    [manageCVMat storeCVMat:E withKey:@"Earray"];
    
    
    
    
    /*
    NSMutableArray *Rarray = [NSMutableArray arrayWithCapacity:9];
    NSNumber* matElemnt;
    for (int i=0 ; i<9 ; i++)
    {
        matElemnt = [NSNumber numberWithDouble:R.at<double>(i/3,i%3)];
        [Rarray insertObject:matElemnt atIndex:i];
        cout << "double" << R.at<double>(i/3,i%3) <<endl;
    }
    [[NSUserDefaults standardUserDefaults] setObject:Rarray forKey:@"Rarray"];   
    
    
    NSMutableArray *Tarray = [NSMutableArray arrayWithCapacity:3];
    
    for (int i=0 ; i<3 ; i++)
    {
        matElemnt = [NSNumber numberWithDouble:T.at<double>(i/3,i%3)];
        [Tarray insertObject:matElemnt atIndex:i];
        cout << "double" << T.at<double>(0,i) <<endl;
    }
    [[NSUserDefaults standardUserDefaults] setObject:Tarray forKey:@"Tarray"];   
    
    
    NSMutableArray *Earray = [NSMutableArray arrayWithCapacity:9];
    
    for (int i=0 ; i<9 ; i++)
    {
        matElemnt = [NSNumber numberWithDouble:R.at<double>(i/3,i%3)];
        [Earray insertObject:matElemnt atIndex:i];
        cout << "double" << E.at<double>(i/3,i%3) <<endl;
    }
    [[NSUserDefaults standardUserDefaults] setObject:Earray forKey:@"Earray"];  
    
    
    NSMutableArray *Farray = [NSMutableArray arrayWithCapacity:9];
    
    for (int i=0 ; i<9 ; i++)
    {
        matElemnt = [NSNumber numberWithDouble:F.at<double>(i/3,i%3)];
        [Farray insertObject:matElemnt atIndex:i];
        cout << "double" << F.at<double>(i/3,i%3) <<endl;
    }
    [[NSUserDefaults standardUserDefaults] setObject:Farray forKey:@"Farray"];   
    
    
    [[NSUserDefaults standardUserDefaults] synchronize];
    */
    
    return rms;
    
}

// omer - this function is new. calculates disparity map from left and right images.

void createMap(const cv::Size imgSize, cv::Mat &map11 , cv::Mat &map12 , cv::Mat &map21 , cv::Mat &map22 ,cv::Rect &roi1 , cv::Rect &roi2)
{
    cv::Mat M1 = *[manageCVMat loadCVMat:cv::Size(3,3) WithKey:@"cameraMatrix1"];
    cv::Mat M2 = *[manageCVMat loadCVMat:cv::Size(3,3) WithKey:@"cameraMatrix2"];
    cv::Mat D1 = *[manageCVMat loadCVMat:cv::Size(1,5) WithKey:@"distCoeffs1"];
    cv::Mat D2 = *[manageCVMat loadCVMat:cv::Size(1,5) WithKey:@"distCoeffs2"];
    cv::Mat R = *[manageCVMat loadCVMat:cv::Size(3,3) WithKey:@"Rarray"];
    cv::Mat T = *[manageCVMat loadCVMat:cv::Size(1,3) WithKey:@"Tarray"];
    
    cv::Size img_size = imgSize;
    cv::Mat Q;
    
    Mat R1, P1, R2, P2;
    
    
    cv::stereoRectify( M1, D1, M2, D2, img_size, R, T, R1, R2, P1, P2, Q, CALIB_ZERO_DISPARITY, -1, img_size, &roi1, &roi2 );
    
    cv::initUndistortRectifyMap(M1, D1, R1, P1, img_size, CV_16SC2, map11, map12);
    cv::initUndistortRectifyMap(M2, D2, R2, P2, img_size, CV_16SC2, map21, map22);

}

void reconstruct(cv::Size imageSize , cv::Mat* img1 , cv::Mat* img2 ,cv::Mat* outImg,cv::Mat &map11 , cv::Mat &map12 , cv::Mat &map21 , cv::Mat &map22 ,cv::Rect &roi1 , cv::Rect &roi2)
{
    enum { STEREO_BM=0, STEREO_SGBM=1, STEREO_HH=2, STEREO_VAR=3 };
    int SADWindowSize = 0, numberOfDisparities = 0;

    
    StereoBM bm;
    StereoSGBM sgbm;
    StereoVar var;
    cv::Size img_size = img1->size();
    

        
    cv::Mat img1r, img2r;
    cv::remap(*img1, img1r, map11, map12, INTER_LINEAR);
    cv::remap(*img2, img2r, map21, map22, INTER_LINEAR);
        
    *img1 = img1r;
    *img2 = img2r;
    
    numberOfDisparities = numberOfDisparities > 0 ? numberOfDisparities : ((img_size.width/8) + 15) & -16;
    
    bm.state->roi1 = roi1;
    bm.state->roi2 = roi2;
    bm.state->preFilterCap = 31;
    bm.state->SADWindowSize = SADWindowSize > 0 ? SADWindowSize : 9;
    bm.state->minDisparity = 0;
    bm.state->numberOfDisparities = numberOfDisparities;
    bm.state->textureThreshold = 10;
    bm.state->uniquenessRatio = 15;
    bm.state->speckleWindowSize = 100;
    bm.state->speckleRange = 32;
    bm.state->disp12MaxDiff = 1;

    Mat disp, disp8;
    
    bm(*img1, *img2, disp);

    disp.convertTo(disp8, CV_8U);
    *outImg = disp8;

    }

