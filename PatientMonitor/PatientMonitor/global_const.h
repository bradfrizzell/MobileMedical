//
//  global_const.h
//  PatientMonitor
//
//  Created by Alex Henry on 11/11/14.
//  Copyright (c) 2014 Alexander Henry. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface global_const : NSObject

// Viewing window constants
extern int const guide_top;
extern int const guide_bottom;
extern int const guide_left;
extern int const guide_right;

// Expand button constants
extern int const space_left_expand; // space between right of enclosing window and left of expand button
extern int const space_top_expand;  // space between top of window and top of expand button
extern int const height_expand;
extern int const width_expand;

// Alarm button constants
extern int const space_left_alarm; // space between right of enclosing window and left of alarm button
extern int const space_top_alarm;  // space between top of window and top of alarm button
extern int const height_alarm;
extern int const width_alarm;

// Graph window constants
extern int const space_graph_x;
extern int const space_graph_y;
extern int const width_graph;

// Nav buttons constants
extern int const nav_guide_top;
extern int const nav_guide_bottom;
extern int const nav_guide_left;
extern int const nav_guide_right;

@end
