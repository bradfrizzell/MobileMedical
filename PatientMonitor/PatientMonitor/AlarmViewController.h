//
//  AlarmViewController.h
//  PatientMonitor
//
//  Created by Alex Henry on 11/12/14.
//  Copyright (c) 2014 Alexander Henry. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol setAlarmDelegate <NSObject>
@required
- (void)selectedAlarmOfObjectIndex:(int)index withMax:(float)max andMin:(float)min;
@end

@interface AlarmViewController : UIViewController

@property (nonatomic, weak) id <setAlarmDelegate> delegate;

- (id)initWithIndex:(int)objectIndex;


@end
