//
//  AlarmViewController.m
//  PatientMonitor
//
//  Created by Alex Henry on 11/12/14.
//  Copyright (c) 2014 Alexander Henry. All rights reserved.
//

#import "AlarmViewController.h"

@interface AlarmViewController ()

@property (nonatomic, strong) UISlider* maxSlider;
@property (nonatomic, strong) UISlider* minSlider;
@property (nonatomic) int objectIndex;

@end

@implementation AlarmViewController

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Handles loading the initial view and populates the view with stuff
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.maxSlider = [self createSlider:CGRectMake(50, 20, 200, 20) withTag:1];
    self.minSlider = [self createSlider:CGRectMake(50, 60, 200, 20) withTag:2];
    
    UIButton *setButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [setButton addTarget:self
                  action:@selector(handleSetButton:)
        forControlEvents:UIControlEventTouchUpInside];
    [setButton setFrame:CGRectMake(225, 100, 50, 50)];
    [setButton setBackgroundColor:[UIColor darkGrayColor]];
    [setButton setTitle:@"Set!" forState:UIControlStateNormal];

    [self.view addSubview:setButton];

}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Prepares all views by sizing and displaying properly
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Initializes the size of the view controller inside the popover
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)initWithIndex:(int)objectIndex {
    
    self.objectIndex = objectIndex;
    self.preferredContentSize = CGSizeMake(300, 150);
    
    return self;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Creates the slider with the specified settings
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-(UISlider*)createSlider:(CGRect)frame withTag:(int)tag {
    UISlider *slider = [[UISlider alloc] initWithFrame:frame];
    [slider addTarget:self action:@selector(sliderAction:) forControlEvents:UIControlEventValueChanged];
    [slider setBackgroundColor:[UIColor clearColor]];
    [slider setTag:tag];
    slider.minimumValue = 0.0;
    slider.maximumValue = 50.0;
    slider.continuous = YES;
    slider.value = 25.0;
    [self.view addSubview:slider];
    
    return slider;
}

-(void)sliderAction:(id)sender {
//    UISlider *slider = (UISlider*)sender;
//    float value = slider.value;
    //-- Do further actions
}

-(IBAction)handleSetButton:(id)sender {

    if (self.delegate != nil) {
        [self.delegate selectedAlarmOfObjectIndex:self.objectIndex withMax:self.maxSlider.value andMin:self.minSlider.value];
    }
}

@end
