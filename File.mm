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

    
    Mat cameraMatrix[2], distCoeffs[2];
    cameraMatrix[0] = Mat::eye(3, 3, CV_64F);
    cameraMatrix[1] = Mat::eye(3, 3, CV_64F);
    Mat R, T, E, F;
    
    double rms = stereoCalibrate(objectPoints, imagePoints[0], imagePoints[1],
                                 cameraMatrix[0], distCoeffs[0],
                                 cameraMatrix[1], distCoeffs[1],
                                 imageSize, R, T, E, F,
                                 TermCriteria(CV_TERMCRIT_ITER+CV_TERMCRIT_EPS, 100, 1e-5),
                                 CV_CALIB_FIX_ASPECT_RATIO +
                                 CV_CALIB_ZERO_TANGENT_DIST +
                                 CV_CALIB_SAME_FOCAL_LENGTH +
                                 CV_CALIB_RATIONAL_MODEL +
                                 CV_CALIB_FIX_K3 + CV_CALIB_FIX_K4 + CV_CALIB_FIX_K5);
    
    
    
    
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
