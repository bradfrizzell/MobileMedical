//
//  SettingsViewController.m
//  PatientMonitor
//
//  Created by Alex Henry on 11/11/14.
//  Copyright (c) 2014 Alexander Henry. All rights reserved.
//

#import "SettingsViewController.h"
#import "ViewController.h"
#import "VitalSign.h"
#import "global_const.h"
#import <QuartzCore/QuartzCore.h>

@interface SettingsViewController ()

@end

@implementation SettingsViewController


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Handles loading the initial view and populates the view with stuff
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    NSString* buttonTitle;
    
    self.check_buttons = [[NSMutableArray arrayWithCapacity:[self.object_list count]] init];

    for (int i = 0; i < [self.object_list count]; i++) {
        if (i % 4 == 0)
            buttonTitle = @"ECG";
        else if (i % 4 == 1)
            buttonTitle = @"Pulse Rate";
        else if (i % 4 == 2)
            buttonTitle = @"Temperature";
        else if (i % 4 == 3)
            buttonTitle = @"Blood Pressure";
        [self.check_buttons addObject: [self addCheckButton:i withTitle:buttonTitle]];
    }
    
    [self addNavButton:@"Back" atLeftAlign:(2*180)];
    [self addNavButton:@"Set" atLeftAlign:(4*180)];
    
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// IBAction to respond to navigation button touches
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (IBAction)handleNavButton:(id)sender {
    UIButton *buttonClicked = (UIButton *)sender;
    
    if ([buttonClicked.titleLabel.text isEqual: @"Back"])
        [self dismissViewControllerAnimated:YES completion:nil];
    else if ([buttonClicked.titleLabel.text  isEqual: @"Set"])
        [self performSegueWithIdentifier:@"unwindToDefaultSegue" sender:self];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Prepare the data for a segue (segue identifier must be specified)
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"unwindToDefaultSegue"]) {

    }
}*/

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Handle what happens when a check button is clicked
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (IBAction)handleCheckButton:(id)sender {
    UIButton *buttonClicked = (UIButton *)sender;
    
    //int indexOfClickedButton = buttonClicked.tag;
    //This next for loop checks to see which button is expanded...
    int indexOfClickedButton = 0;
    for (int i = 0; i < [self.object_list count]; i++) {
        if ([[self.check_buttons objectAtIndex:i] isEqual:buttonClicked]) {
            indexOfClickedButton = i;
            break;
        }
    }
    
    if ([[self.object_list objectAtIndex:indexOfClickedButton] isDisplayed]) {
        buttonClicked.backgroundColor = [UIColor blackColor];
        ((VitalSign*)[self.object_list objectAtIndex:indexOfClickedButton]).isDisplayed = false;
        self.num_conf_buttons--;
    }
    else {
        buttonClicked.backgroundColor = [UIColor blueColor];
        ((VitalSign*)[self.object_list objectAtIndex:indexOfClickedButton]).isDisplayed = true;
        self.num_conf_buttons++;
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Creates a standard check button with a specified title
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (UIButton*)addCheckButton:(int)buttonNumber withTitle:(NSString*)buttonTitle {
    UIButton *button = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    
    [button addTarget:self
               action:@selector(handleCheckButton:)
     forControlEvents:UIControlEventTouchUpInside];
    
    [button setFrame:CGRectMake( guide_left, guide_top+1+buttonNumber*(guide_bottom-guide_top)/([self.object_list count]), (guide_right-guide_left), (guide_bottom-guide_top)/([self.object_list count])-2)];
    [button setTitle:buttonTitle forState:UIControlStateNormal];
    [button setTag:buttonNumber];
    
    [button setBackgroundColor:[UIColor blackColor]];
    [button setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    button.layer.borderColor = [UIColor whiteColor].CGColor;
    button.layer.borderWidth = 5.0;
    button.layer.cornerRadius = 10;
    
    [self.view addSubview:button];
    return button;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Creates and displays the navigation button
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)addNavButton:(NSString*)title atLeftAlign:(int)left {
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
/*    if ([title isEqualToString:@"Set"])
        [navButton addTarget:self action:@selector(unwindToMain:) forControlEvents:UIControlEventTouchUpInside];
    else*/
        [navButton addTarget:self action:@selector(handleNavButton:) forControlEvents:UIControlEventTouchUpInside];
    [navButton setFrame:CGRectMake(left, (guide_bottom+20), 180, 68)];
    [navButton setTitle:title forState:UIControlStateNormal];
    [navButton setBackgroundColor:[UIColor blackColor]];
    navButton.layer.borderColor = [UIColor blueColor].CGColor;
    navButton.layer.borderWidth = 5.0;
    navButton.layer.cornerRadius = 10;
    [self.view addSubview:navButton];
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
