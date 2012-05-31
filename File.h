//
//  Header.h
//  OpenCVClient
//
//  Created by Ron Slossberg on 4/24/12.
//  Copyright (c) 2012 Aptogo Limited. All rights reserved.
//
#ifndef OpenCVClient_Header_h
#define OpenCVClient_Header_h


#include "opencv2/opencv.hpp"
#include "opencv2/calib3d/calib3d.hpp"
#include "opencv2/highgui/highgui.hpp"
#include "opencv2/imgproc/imgproc.hpp"
#import "UIImage+OpenCV.h"


#include <vector>
#include <string>
#include <algorithm>
#include <iostream>
#include <iterator>
#include <stdio.h>
#include <stdlib.h>
#include <ctype.h>

bool StereoCalib(cv::Mat img , cv::Size boardSize,cv::vector<cv::vector<cv::Point2f> > (&imagePoints)[2], int numImage , cv::Mat& cornersImg);
double calibrateCameras( cv::Size boardSize,cv::vector<cv::vector<cv::Point2f> >(& imagePoints)[2], cv::vector<cv::vector<cv::Point3f> >& objectPoints, int numImage , cv::Size imageSize);

#endif