//
//  VitalSign.h
//  PatientMonitor
//
//  Created by Alex Henry on 11/11/14.
//  Copyright (c) 2014 Alexander Henry. All rights reserved.
//

#import "Graph.h"
#import "AlarmViewController.h"
#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface VitalSign : NSObject

@property NSString *title;
@property NSMutableArray *data;
@property (nonatomic, strong) AlarmViewController *alarmVC;
@property (nonatomic, strong) UIPopoverController *alarmPopover;
@property UIButton *expand;
@property UIButton *alarm;
@property UIView *window;
@property Graph *graph;
@property bool isSelected;
@property bool isSelected2;
@property bool isDisplayed;
@property float maxAlarm;
@property float minAlarm;


@end
