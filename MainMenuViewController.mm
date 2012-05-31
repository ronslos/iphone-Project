//
//  MainMenuViewController.m
//  3d_visioin
//
//  Created by Ron Slossberg on 4/30/12.
//  Copyright (c) 2012 ronslos@gmail.com. All rights reserved.
//

#import "MainMenuViewController.h"
#import "CalibrationViewClontroller.h"
#import "SessionManager.h"
#import "SettingsViewController.h"

@interface MainMenuViewController ()

@end

@implementation MainMenuViewController



- (IBAction)settingsPressed:(id)sender {
    
    SettingsViewController* settingsViewController = [[SettingsViewController alloc] init];
    [self.navigationController pushViewController:settingsViewController animated:YES];
    [settingsViewController release];
}

-(IBAction)calibratePressed:(id)sender
{
    CalibrationViewController* calibrationViewController = [[CalibrationViewController alloc] init];
    [self.navigationController pushViewController:calibrationViewController animated:YES];
    [calibrationViewController release];
}
-(IBAction)connectDevicePressed:(id)sender
{
    _sessionManager = [SessionManager instance];
    [_sessionManager initializeSession];
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    //Do any additional setup after loading the view from its nib.
}

- (void)viewDidUnload
{

    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}



- (void)dealloc {

    [super dealloc];
}
@end
