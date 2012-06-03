//
//  SettingsViewController.h
//  3d_visioin
//
//  Created by Ron Slossberg on 5/31/12.
//  Copyright (c) 2012 ronslos@gmail.com. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SettingsViewController : UIViewController <UITextFieldDelegate>

@property (retain, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (retain, nonatomic) IBOutlet UILabel *R1_1;
@property (retain, nonatomic) IBOutlet UILabel *R1_2;
@property (retain, nonatomic) IBOutlet UILabel *R1_3;
@property (retain, nonatomic) IBOutlet UILabel *R2_1;
@property (retain, nonatomic) IBOutlet UILabel *R2_2;
@property (retain, nonatomic) IBOutlet UILabel *R2_3;
@property (retain, nonatomic) IBOutlet UILabel *R3_1;
@property (retain, nonatomic) IBOutlet UILabel *R3_2;
@property (retain, nonatomic) IBOutlet UILabel *R3_3;
@property (retain, nonatomic) IBOutlet UILabel *T1_1;
@property (retain, nonatomic) IBOutlet UILabel *T2_1;
@property (retain, nonatomic) IBOutlet UILabel *T3_1;
@property (retain, nonatomic) IBOutlet UILabel *E1_1;
@property (retain, nonatomic) IBOutlet UILabel *E1_2;
@property (retain, nonatomic) IBOutlet UILabel *E1_3;
@property (retain, nonatomic) IBOutlet UILabel *E2_1;
@property (retain, nonatomic) IBOutlet UILabel *E2_2;
@property (retain, nonatomic) IBOutlet UILabel *E2_3;
@property (retain, nonatomic) IBOutlet UILabel *E3_1;
@property (retain, nonatomic) IBOutlet UILabel *E3_2;
@property (retain, nonatomic) IBOutlet UILabel *E3_3;
@property (retain, nonatomic) IBOutlet UILabel *F1_1;
@property (retain, nonatomic) IBOutlet UILabel *F1_2;
@property (retain, nonatomic) IBOutlet UILabel *F1_3;
@property (retain, nonatomic) IBOutlet UILabel *F2_1;
@property (retain, nonatomic) IBOutlet UILabel *F2_2;
@property (retain, nonatomic) IBOutlet UILabel *F2_3;
@property (retain, nonatomic) IBOutlet UILabel *F3_1;
@property (retain, nonatomic) IBOutlet UILabel *F3_2;
@property (retain, nonatomic) IBOutlet UILabel *F3_3;
@property (retain, nonatomic) IBOutlet UITextField *boardWidthText;
@property (retain, nonatomic) IBOutlet UITextField *boardHeightText;
@property (retain, nonatomic) IBOutlet UITextField *squareSizeText;
- (IBAction)saveBoardWidth:(UITextField*)sender;
- (IBAction)saveBoardHeight:(UITextField*)sender;
- (IBAction)saveSquareSize:(UITextField*)sender;


@end
