//
//  AppDelegate.h
//  3d_visioin
//
//  Created by Ron Slossberg on 4/27/12.
//  Copyright (c) 2012 ronslos@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CalibrationViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>

@property (nonatomic, retain) IBOutlet UIWindow *window;

@property (nonatomic, retain) IBOutlet CalibrationViewController *viewController;

@end
