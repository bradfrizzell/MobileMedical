//
//  ViewController.h
//  PatientMonitor
//
//  Created by Alex Henry on 11/11/14.
//  Copyright (c) 2014 Alexander Henry. All rights reserved.
//

#import "AlarmViewController.h"
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <setAlarmDelegate>

@property NSMutableArray* object_list;
@property int num_objects;
@property bool display_conf_flag;   // true = configured display; false = default display

- (IBAction)unwindToMain:(UIStoryboardSegue *)segue;


@end

