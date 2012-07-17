//
//  manageCVMat.h
//  3d_visioin
//
//  Created by Ron Slossberg on 6/1/12.
//  Copyright (c) 2012 ronslos@gmail.com. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "File.h"

@interface manageCVMat : NSObject

+(void) storeCVMat: (cv::Mat) mat withKey: (NSString*) key;
+(cv::Mat) loadCVMat: (cv::Size) size  WithKey: (NSString*) key;

@end
