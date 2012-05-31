//
//  AppDelegate.h
//  3d_visioin
//
//  Created by Ron Slossberg on 4/27/12.
//  Copyright (c) 2012 ronslos@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CalibrationViewController;
@class MainMenuViewController;

@interface AppDelegate : NSObject <UIApplicationDelegate>
{
    UINavigationController * navigationController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;

@end
