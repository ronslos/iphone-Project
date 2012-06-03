//
//  SettingsViewController.mm
//  3d_visioin
//
//  Created by Ron Slossberg on 5/31/12.
//  Copyright (c) 2012 ronslos@gmail.com. All rights reserved.
//

#import "SettingsViewController.h"
#import "UIImage+OpenCV.h"
//#import "File.h"

@interface SettingsViewController ()

@end

@implementation SettingsViewController
@synthesize scrollerView;
@synthesize R1_1;
@synthesize R1_2;
@synthesize R1_3;
@synthesize R2_1;
@synthesize R2_2;
@synthesize R2_3;
@synthesize R3_1;
@synthesize R3_2;
@synthesize R3_3;
@synthesize T1_1;
@synthesize T2_1;
@synthesize T3_1;
@synthesize E1_1;
@synthesize E1_2;
@synthesize E1_3;
@synthesize E2_1;
@synthesize E2_2;
@synthesize E2_3;
@synthesize E3_1;
@synthesize E3_2;
@synthesize E3_3;
@synthesize F1_1;
@synthesize F1_2;
@synthesize F1_3;
@synthesize F2_1;
@synthesize F2_2;
@synthesize F2_3;
@synthesize F3_1;
@synthesize F3_2;
@synthesize F3_3;
@synthesize boardWidthText;
@synthesize boardHeightText;
@synthesize squareSizeText;


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
    
    
    [self.squareSizeText setReturnKeyType:UIReturnKeyDone];
    [self.boardWidthText setReturnKeyType:UIReturnKeyDone];
    [self.boardHeightText setReturnKeyType:UIReturnKeyDone];
    [self.squareSizeText setDelegate:self];
    [self.boardHeightText setDelegate:self];
    [self.boardWidthText setDelegate:self];
    
    NSString* boardWidth = (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:@"boardWidth"];
    NSString* boardHeight = (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:@"boardHeight"];
    NSString* squareSize = (NSString*) [[NSUserDefaults standardUserDefaults] objectForKey:@"squareSize"];
    
    [self.boardWidthText setText:boardWidth];
    [self.boardHeightText setText:boardHeight];
    [self.squareSizeText setText:squareSize];
    
    
    
    // Do any additional setup after loading the view from its nib.
    [self.scrollerView setContentSize:CGSizeMake(320, 900)];
    NSMutableArray* RArray = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"Rarray"];
    
    NSMutableArray* TArray = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"Tarray"];
    
    NSMutableArray* EArray = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"Earray"];
    
    NSMutableArray* FArray = (NSMutableArray*)[[NSUserDefaults standardUserDefaults] objectForKey:@"Farray"];
    
    NSString *text;
    
    for (int i=0; i<9; i++) {
        text = [NSString stringWithFormat:@"%.2f",[(NSNumber*)[RArray objectAtIndex:i] doubleValue ]];
        [(UILabel*) [self.scrollerView viewWithTag:(i+1)] setText:text];
    }
    
    for (int i=0; i<3; i++) {
        text = [NSString stringWithFormat:@"%.2f",[(NSNumber*)[TArray objectAtIndex:i] doubleValue ]];
        [(UILabel*) [self.scrollerView viewWithTag:(i+10)] setText:text];
    }
    
    for (int i=0; i<9; i++) {
        text = [NSString stringWithFormat:@"%.2f",[(NSNumber*)[EArray objectAtIndex:i] doubleValue ]];
        [(UILabel*) [self.scrollerView viewWithTag:(i+13)] setText:text];
    }
    
    for (int i=0; i<9; i++) {
        text = [NSString stringWithFormat:@"%.2f",[(NSNumber*)[FArray objectAtIndex:i] doubleValue ]];
        [(UILabel*) [self.scrollerView viewWithTag:(i+22)] setText:text];
    }
    
    
    
}

- (void)viewDidUnload
{
    [self setScrollerView:nil];
    [self setR1_1:nil];
    [self setR1_2:nil];
    [self setR1_3:nil];
    [self setR2_1:nil];
    [self setR2_2:nil];
    [self setR2_3:nil];
    [self setR3_1:nil];
    [self setR3_2:nil];
    [self setR3_3:nil];
    [self setT1_1:nil];
    [self setT2_1:nil];
    [self setT3_1:nil];
    [self setE1_1:nil];
    [self setE1_2:nil];
    [self setE1_3:nil];
    [self setE2_1:nil];
    [self setE2_2:nil];
    [self setE2_3:nil];
    [self setE3_1:nil];
    [self setE3_2:nil];
    [self setE3_3:nil];
    [self setF1_1:nil];
    [self setF1_2:nil];
    [self setF1_3:nil];
    [self setF2_1:nil];
    [self setF2_2:nil];
    [self setF2_3:nil];
    [self setF3_1:nil];
    [self setF3_2:nil];
    [self setF3_3:nil];
    [self setBoardWidthText:nil];
    [self setBoardHeightText:nil];
    [self setSquareSizeText:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

- (void)dealloc {
    [scrollerView release];
    [R1_1 release];
    [R1_2 release];
    [R1_3 release];
    [R2_1 release];
    [R2_2 release];
    [R2_3 release];
    [R3_1 release];
    [R3_2 release];
    [R3_3 release];
    [T1_1 release];
    [T2_1 release];
    [T3_1 release];
    [E1_1 release];
    [E1_2 release];
    [E1_3 release];
    [E2_1 release];
    [E2_2 release];
    [E2_3 release];
    [E3_1 release];
    [E3_2 release];
    [E3_3 release];
    [F1_1 release];
    [F1_2 release];
    [F1_3 release];
    [F2_1 release];
    [F2_2 release];
    [F2_3 release];
    [F3_1 release];
    [F3_2 release];
    [F3_3 release];
    [boardWidthText release];
    [boardHeightText release];
    [squareSizeText release];
    [super dealloc];
}


- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    return NO;
}

- (IBAction)saveBoardWidth:(UITextField *)sender{
    [[NSUserDefaults standardUserDefaults] setObject: sender.text forKey:@"boardWidth"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)saveBoardHeight:(UITextField *)sender {
    [[NSUserDefaults standardUserDefaults] setObject: sender.text forKey:@"boardHeight"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}

- (IBAction)saveSquareSize:(UITextField *)sender {
    [[NSUserDefaults standardUserDefaults] setObject: sender.text forKey:@"squareSize"];
    [[NSUserDefaults standardUserDefaults] synchronize];
}
@end
