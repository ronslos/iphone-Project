//
//  MainMenuViewController.h
//  3d_visioin
//
//  Created by Ron Slossberg on 4/30/12.
//  Copyright (c) 2012 ronslos@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SessionManager.h"

@interface MainMenuViewController : UIViewController 

{
    SessionManager* _sessionManager;
}

- (IBAction)settingsPressed:(UIButton*)sender;
-(IBAction)calibratePressed:(UIButton*)sender;
-(IBAction)connectDevicePressed:(UIButton*)sender;

@end
