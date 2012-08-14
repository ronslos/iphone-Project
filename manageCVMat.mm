//
//  manageCVMat.m
//  3d_visioin
//
//  Created by Ron Slossberg on 6/1/12.
//  Copyright (c) 2012 ronslos@gmail.com. All rights reserved.
//

#import "manageCVMat.h"


@implementation manageCVMat
// Omer - note changes in both functions. use this file instead.
+(void) storeCVMat: (cv::Mat) mat withKey: (NSString*) key{
    
    int matRows = mat.rows;
    int matCols = mat.cols;
    NSMutableArray *matArray = [NSMutableArray arrayWithCapacity: matRows * matCols];
    NSNumber* matElemnt;
    for (int i=0 ; i< matRows * matCols; i++)
    {
        if(matRows != 1 && matCols != 1){
            matElemnt = [NSNumber numberWithFloat:mat.at<double>(i/matCols,i%matRows)];
        }
        else{
            matElemnt = [NSNumber numberWithFloat:mat.at<double>(i)];
        }
        [matArray insertObject:matElemnt atIndex:i];


    }
    [[NSUserDefaults standardUserDefaults] setObject:matArray forKey:key];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

+(cv::Mat*) loadCVMat: (cv::Size) size  WithKey: (NSString*) key {
    
    cv::Mat* result = new cv::Mat(size,CV_64F);
    NSMutableArray* matArray = (NSMutableArray*) [[NSUserDefaults standardUserDefaults] objectForKey:key];
    for (int i=0 ; i< size.width * size.height; i++)
    {
        if(size.width != 1 && size.height != 1){
            result->at<double>(i/size.width,i%size.height) = [(NSNumber*)[matArray objectAtIndex:i ] doubleValue];
        }
        else
        {
            result->at<double>(i) = [(NSNumber*)[matArray objectAtIndex:i ] doubleValue];
        }
    }
    
    return result;
}

@end
