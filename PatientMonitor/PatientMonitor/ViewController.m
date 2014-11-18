//
//  ViewController.m
//  PatientMonitor
//
//  Created by Alex Henry on 11/11/14.
//  Copyright (c) 2014 Alexander Henry. All rights reserved.
//

#import "ViewController.h"
#import "SettingsViewController.h"
#import "AlarmViewController.h"
#import "VitalSign.h"
#import "Graph.h"
#import "Data.h"
#import "global_const.h"
#import <QuartzCore/QuartzCore.h>

@interface ViewController ()


@end

@implementation ViewController


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Handles loading the initial view and populates the view with stuff
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.

    UIColor *viewColor;
    NSString *viewTitle;
    bool viewGraph;
    
    
    self.display_conf_flag = false;
    self.num_objects = 6;
    self.object_list = [[NSMutableArray arrayWithCapacity:(self.num_objects)] init];
    
    for (int i = 0; i < self.num_objects; i++) {
        if (i == 0) {
            viewColor = [UIColor blueColor];
            viewTitle = @"ECG";
            viewGraph = true;
        }
        else if (i == 1) {
            viewColor = [UIColor greenColor];
            viewTitle = @"Pulse Rate";
            viewGraph = true;
        }
        else if (i == 2) {
            viewColor = [UIColor redColor];
            viewTitle = @"Temperature";
            viewGraph = true;
        }
        else {
            viewColor = [UIColor yellowColor];
            viewTitle = @"Blood Pressure";
            viewGraph = false;
        }
        [self.object_list addObject: [self makeObject:i withTitle:viewTitle withColor:viewColor withGraph:viewGraph]];
    }
    
    // Creates the navigation button
    [self addNavButton:@"Menu" fromLeft:1];
    [self addNavButton:@"Default Screen" fromLeft:2];
    [self addNavButton:@"Configured Screen" fromLeft:3];
    [self addNavButton:@"Settings" fromLeft:4];
    
    //[NSTimer scheduledTimerWithTimeInterval: 2.0 target:self selector:@selector(printRandom) userInfo: nil repeats:YES];

}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Sets the status bar colors to contrast with the black background
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Prepares all views by sizing and displaying properly
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self sizeViews:self.object_list];
    [self showViews:self.object_list];
    
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Creates an object and fills in every data field
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (VitalSign*)makeObject:(int)buttonNumber withTitle:(NSString*)buttonTitle withColor:(UIColor*)buttonColor withGraph:(bool)showGraph {
    VitalSign *object = [[VitalSign alloc] init];
    UIButton *expand = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIButton *alarm = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    UIView *window = [[UIView alloc] init];
    Graph *graphobj = [[Graph alloc] initWithFrame:CGRectMake(0, 0, (guide_right-guide_left)/2, (guide_bottom-guide_top)/(4)-(2*space_graph_y))];
    Data *sampledata = [[Data alloc] init];
    
    [expand addTarget:self action:@selector(handleExpandAction:) forControlEvents:UIControlEventTouchUpInside];
    [expand setBackgroundColor:[UIColor blackColor]];
    [expand setTitleColor:buttonColor forState:UIControlStateNormal];
    expand.layer.borderColor = buttonColor.CGColor;
    expand.layer.borderWidth = 5.0;
    expand.layer.cornerRadius = 5;
    
    [alarm addTarget:self action:@selector(handleAlarmAction:) forControlEvents:UIControlEventTouchUpInside];
    [alarm setBackgroundColor:[UIColor blackColor]];
    alarm.layer.borderColor = buttonColor.CGColor;
    alarm.layer.borderWidth = 5.0;
    alarm.layer.cornerRadius = 5;
    
    [window setBackgroundColor:[UIColor blackColor]];
    window.layer.borderColor = buttonColor.CGColor;
    window.layer.borderWidth = 5.0;
    window.layer.cornerRadius = 10;
    
    if (showGraph) {
        [graphobj.graphXData addObjectsFromArray:[sampledata getDataX]];
        [graphobj.graphYData addObjectsFromArray:[sampledata getDataY]];
        [graphobj setGraphColor:buttonColor];
    }
    else
        graphobj = NULL;

    
    object.title = buttonTitle;
    object.isDisplayed = false;
    object.isSelected = false;
    object.isSelected2 = false;
    object.data = NULL;
    object.maxAlarm = 0;
    object.minAlarm = 0;
    object.expand = expand;
    object.alarm = alarm;
    object.window = window;
    object.graph = graphobj;
    
    return object;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Size the button heights according to what has been selected
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)sizeViews:(NSMutableArray*)array {

    // Initialize all variables to create proper sizing
    int num_no_graph = 0;
    int num_row = 0;
    int num_selected = 0;
    
    // Displaying the default display screen - calculate used variables
    if (!self.display_conf_flag) {
        for (int i = 0; i < [array count]; i++) {
            if ([[array objectAtIndex:i] graph] != NULL) {
                num_row++;
                if ([[array objectAtIndex:i] isSelected])
                    num_selected++;
            }
            else {
                if (num_no_graph == 0) {
                    num_row++;
                    if ([[array objectAtIndex:i] isSelected])
                        num_selected++;
                }
                num_no_graph++;
            }
        }
    }
    // Displaying the configured display screen - calculate used variables
    else {
        for (int i = 0; i < [array count]; i++) {
            if ([[array objectAtIndex:i] isDisplayed]) {
                if ([[array objectAtIndex:i] graph] != NULL) {
                    num_row++;
                    if ([[array objectAtIndex:i] isSelected2])
                        num_selected++;
                }
                else {
                    if (num_no_graph == 0) {
                        num_row++;
                        if ([[array objectAtIndex:i] isSelected2])
                            num_selected++;
                    }
                    num_no_graph++;
                }
            }
        }
    }
    // Don't allow a single view to "expand"
    if ( (num_selected == 1) && (num_row == 1) )
        num_selected = 0;
    
    
    // On the default screen
    if (!self.display_conf_flag) {
        
        int window_top = 0;
        int window_left = 0;
        for (int i = 0; i < [array count]; i++) {
            [[array objectAtIndex:i] window].hidden = false;
            [[array objectAtIndex:i] expand].hidden = false;
            if ([[array objectAtIndex:i] graph] != NULL)
                [[array objectAtIndex:i] graph].hidden = false;
            
            // Break up display each window into cases, if selected or not selected
            if ([[array objectAtIndex:i] isSelected]) { // selected
                if ([[array objectAtIndex:i] graph] != NULL) {
                    // Display the window, buttons, and graph
                    [[[array objectAtIndex:i] window] setFrame:CGRectMake(guide_left, guide_top+window_top*(guide_bottom-guide_top)/(num_row+num_selected), (guide_right-guide_left), 2*(guide_bottom-guide_top)/(num_row+num_selected))];
                    [[[array objectAtIndex:i] expand] setFrame:CGRectMake((guide_right-space_left_expand), guide_top+space_top_expand+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_expand, height_expand)];
                    [[[array objectAtIndex:i] alarm] setFrame:CGRectMake((guide_right-space_left_alarm), guide_top+space_top_alarm+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_alarm, height_alarm)];
                    [[[array objectAtIndex:i] graph] setFrame:CGRectMake(guide_left+space_graph_x, guide_top+space_graph_y+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_graph, 2*(guide_bottom-guide_top)/(num_row+num_selected)-(2*space_graph_y))];

                    window_top = window_top + 2;
                }
                else {
                    // Display the window, buttons, but not graph
                    [[[array objectAtIndex:i] window] setFrame:CGRectMake(guide_left+window_left*(guide_right-guide_left)/(num_no_graph), guide_top+window_top*(guide_bottom-guide_top)/(num_row+num_selected), (guide_right-guide_left)/(num_no_graph), 2*(guide_bottom-guide_top)/(num_row+num_selected))];
                    [[[array objectAtIndex:i] expand] setFrame:CGRectMake(guide_left+(window_left+1)*(guide_right-guide_left)/(num_no_graph)-space_left_expand, guide_top+space_top_expand+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_expand, height_expand)];
                    [[[array objectAtIndex:i] alarm] setFrame:CGRectMake(guide_left+(window_left+1)*(guide_right-guide_left)/(num_no_graph)-space_left_alarm, guide_top+space_top_alarm+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_alarm, height_alarm)];

                    window_left = window_left + 1;
                }
            }
            else { // not selected
                if ([[array objectAtIndex:i] graph] != NULL) {
                    // Display the window, buttons, and graph
                    [[[array objectAtIndex:i] window] setFrame:CGRectMake(guide_left, guide_top+window_top*(guide_bottom-guide_top)/(num_row+num_selected), (guide_right-guide_left), (guide_bottom-guide_top)/(num_row+num_selected))];
                    [[[array objectAtIndex:i] expand] setFrame:CGRectMake((guide_right-space_left_expand), guide_top+space_top_expand+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_expand, height_expand)];
                    [[[array objectAtIndex:i] alarm] setFrame:CGRectMake((guide_right-space_left_alarm), guide_top+space_top_alarm+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_alarm, width_alarm)];
                    [[[array objectAtIndex:i] graph] setFrame:CGRectMake(guide_left+space_graph_x, guide_top+space_graph_y+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_graph, (guide_bottom-guide_top)/(num_row+num_selected)-(2*space_graph_y))];
                    
                    window_top = window_top + 1;
                }
                else {
                    // Display the window, buttons, but not graph
                    [[[array objectAtIndex:i] window] setFrame:CGRectMake(guide_left+window_left*(guide_right-guide_left)/(num_no_graph), guide_top+window_top*(guide_bottom-guide_top)/(num_row+num_selected), (guide_right-guide_left)/(num_no_graph), (guide_bottom-guide_top)/(num_row+num_selected))];
                    [[[array objectAtIndex:i] expand] setFrame:CGRectMake(guide_left+(window_left+1)*(guide_right-guide_left)/(num_no_graph)-space_left_expand, guide_top+space_top_expand+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_expand, height_expand)];
                    [[[array objectAtIndex:i] alarm] setFrame:CGRectMake(guide_left+(window_left+1)*(guide_right-guide_left)/(num_no_graph)-space_left_alarm, guide_top+space_top_alarm+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_alarm, height_alarm)];
                    
                    window_left = window_left + 1;
                }
            }
        }
    }
    
    else {
        int window_top = 0;
        int window_left = 0;
        for (int i = 0; i < [array count]; i++) {
            if (![[array objectAtIndex:i] isDisplayed]) {
                [[array objectAtIndex:i] window].hidden = true;
                [[array objectAtIndex:i] expand].hidden = true;
                if ([[array objectAtIndex:i] graph] != NULL)
                    [[array objectAtIndex:i] graph].hidden = true;
            }
            else {
                [[array objectAtIndex:i] window].hidden = false;
                [[array objectAtIndex:i] expand].hidden = false;
                if ([[array objectAtIndex:i] graph] != NULL)
                    [[array objectAtIndex:i] graph].hidden = false;
                
                // Break up display each window into cases, if selected or not selected
                if ([[array objectAtIndex:i] isSelected2]) { // selected
                    if ([[array objectAtIndex:i] graph] != NULL) {
                        // Display the window, buttons, and graph
                        [[[array objectAtIndex:i] window] setFrame:CGRectMake(guide_left, guide_top+window_top*(guide_bottom-guide_top)/(num_row+num_selected), (guide_right-guide_left), 2*(guide_bottom-guide_top)/(num_row+num_selected))];
                        [[[array objectAtIndex:i] expand] setFrame:CGRectMake((guide_right-space_left_expand), guide_top+space_top_expand+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_expand, height_expand)];
                        [[[array objectAtIndex:i] alarm] setFrame:CGRectMake((guide_right-space_left_alarm), guide_top+space_top_alarm+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_alarm, height_alarm)];
                        [[[array objectAtIndex:i] graph] setFrame:CGRectMake(guide_left+space_graph_x, guide_top+space_graph_y+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_graph, 2*(guide_bottom-guide_top)/(num_row+num_selected)-(2*space_graph_y))];
                        
                        window_top = window_top + 2;
                    }
                    else {
                            // Display the window, buttons, but not graph
                            [[[array objectAtIndex:i] window] setFrame:CGRectMake(guide_left+window_left*(guide_right-guide_left)/(num_no_graph), guide_top+window_top*(guide_bottom-guide_top)/(num_row+num_selected), (guide_right-guide_left)/(num_no_graph), 2*(guide_bottom-guide_top)/(num_row+num_selected))];
                            [[[array objectAtIndex:i] expand] setFrame:CGRectMake(guide_left+(window_left+1)*(guide_right-guide_left)/(num_no_graph)-space_left_expand, guide_top+space_top_expand+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_expand, height_expand)];
                            [[[array objectAtIndex:i] alarm] setFrame:CGRectMake(guide_left+(window_left+1)*(guide_right-guide_left)/(num_no_graph)-space_left_alarm, guide_top+space_top_alarm+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_alarm, height_alarm)];
                        
                            window_left = window_left + 1;
                        }
                }
                else { // not selected
                    if ([[array objectAtIndex:i] graph] != NULL) {
                        // Display the window, buttons, and graph
                        [[[array objectAtIndex:i] window] setFrame:CGRectMake(guide_left, guide_top+window_top*(guide_bottom-guide_top)/(num_row+num_selected), (guide_right-guide_left), (guide_bottom-guide_top)/(num_row+num_selected))];
                        [[[array objectAtIndex:i] expand] setFrame:CGRectMake((guide_right-space_left_expand), guide_top+space_top_expand+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_expand, height_expand)];
                        [[[array objectAtIndex:i] alarm] setFrame:CGRectMake((guide_right-space_left_alarm), guide_top+space_top_alarm+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_alarm, height_alarm)];
                        [[[array objectAtIndex:i] graph] setFrame:CGRectMake(guide_left+space_graph_x, guide_top+space_graph_y+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_graph, (guide_bottom-guide_top)/(num_row+num_selected)-(2*space_graph_y))];
                        
                        window_top = window_top + 1;
                    }
                    else {
                        // Display the window, buttons, but not graph
                        [[[array objectAtIndex:i] window] setFrame:CGRectMake(guide_left+window_left*(guide_right-guide_left)/(num_no_graph), guide_top+window_top*(guide_bottom-guide_top)/(num_row+num_selected), (guide_right-guide_left)/(num_no_graph), (guide_bottom-guide_top)/(num_row+num_selected))];
                        [[[array objectAtIndex:i] expand] setFrame:CGRectMake(guide_left+(window_left+1)*(guide_right-guide_left)/(num_no_graph)-space_left_expand, guide_top+space_top_expand+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_expand, height_expand)];
                        [[[array objectAtIndex:i] alarm] setFrame:CGRectMake(guide_left+(window_left+1)*(guide_right-guide_left)/(num_no_graph)-space_left_alarm, guide_top+space_top_alarm+window_top*(guide_bottom-guide_top)/(num_row+num_selected), width_alarm, height_alarm)];
                        
                        window_left = window_left + 1;
                    }
                }
            }
        }
    }
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Display all views
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)showViews:(NSMutableArray*)array {
    for (int i = 0; i< [array count]; i++) {
        [self.view addSubview:[[array objectAtIndex:i] window]];
        [self.view addSubview:[[array objectAtIndex:i] expand]];
        [self.view addSubview:[[array objectAtIndex:i] alarm]];
        [self.view addSubview:[[array objectAtIndex:i] graph]];
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Creates and displays the navigation button
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)addNavButton:(NSString*)title fromLeft:(int)left {
    UIButton *navButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    [navButton addTarget:self
                  action:@selector(handleNavButton:)
        forControlEvents:UIControlEventTouchUpInside];
    [navButton setFrame:CGRectMake(nav_guide_left+left*(nav_guide_right-nav_guide_left)/6, nav_guide_top, (nav_guide_right-nav_guide_left)/6, (nav_guide_bottom-nav_guide_top))];
    [navButton setTitle:title forState:UIControlStateNormal];
    [navButton setImage:[UIImage imageNamed:@"Settings.png"] forState:UIControlStateNormal];
    [navButton setBackgroundColor:[UIColor clearColor]];
    //navButton.layer.borderColor = [UIColor blueColor].CGColor;
    //navButton.layer.borderWidth = 5.0;
    //navButton.layer.cornerRadius = 10;
    [self.view addSubview:navButton];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// IBAction to respond to navigation button touches
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (IBAction)handleNavButton:(id)sender {
    UIButton *buttonClicked = (UIButton *)sender;
    if ([buttonClicked.titleLabel.text  isEqual: @"Default Screen"]) {
        self.display_conf_flag = false;
        [self sizeViews:self.object_list];
    }
    else if ([buttonClicked.titleLabel.text  isEqual: @"Configured Screen"]) {
        self.display_conf_flag = true;
        [self sizeViews:self.object_list];
    }
    else if ([buttonClicked.titleLabel.text  isEqual: @"Settings"]) {
        [self performSegueWithIdentifier:@"DefaultToSettingsSegue" sender:self];
    }
    else if ([buttonClicked.titleLabel.text  isEqual: @"Menu"]) {
        [self performSegueWithIdentifier:@"DefaultToMenuSegue" sender:self];
    }
    
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Receives relevent information from settings view controller
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (IBAction)unwindToMain:(UIStoryboardSegue*)segue {
    self.display_conf_flag = true;
    
    //self.num_selected2 = 0;
    for (int i = 0; i < [self.object_list count]; i++) {
        ((VitalSign*)[self.object_list objectAtIndex:i]).isSelected2 = false;
    }
    
    [self sizeViews:self.object_list];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Passes relevant information to new view controller
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    if([segue.identifier isEqualToString:@"DefaultToSettingsSegue"]) {
        SettingsViewController *destinationVC = segue.destinationViewController;
        for (int i = 0; i < [self.object_list count]; i++) {
            ((VitalSign*)[self.object_list objectAtIndex:i]).isDisplayed = false;
        }
        destinationVC.object_list = self.object_list;
        NSLog(@"Settings controller");

    }
    if([segue isKindOfClass:[UIStoryboardPopoverSegue class]]) {
        NSLog(@"Popover controller");
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Adds or removes the action for main buttons
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*- (void)changeExpandAction:(NSMutableArray*)array turn:(bool)turnOn {
    if (turnOn) {
        for (int i = 0; i < ([array count]); i++) {
            [[[array objectAtIndex:i] expand] addTarget:self action:@selector(handleExpandAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
    else {
        for (int i = 0; i < ([array count]); i++) {
            [[[array objectAtIndex:i] expand] removeTarget:self action:@selector(handleExpandAction:) forControlEvents:UIControlEventTouchUpInside];
        }
    }
}*/

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Resizes the view heights so that the clicked has double height than the rest
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (IBAction)handleExpandAction:(id)sender {
    UIButton *buttonClicked = (UIButton *)sender;
    
    //This next for loop checks to see which button is expanded...
    int indexOfClickedButton = 0;
    for (int i = 0; i < [self.object_list count]; i++) {
        if ([[[self.object_list objectAtIndex:i] expand] isEqual:buttonClicked]) {
            indexOfClickedButton = i;
            break;
        }
    }
    
    if (!self.display_conf_flag) {
        if ([[self.object_list objectAtIndex:indexOfClickedButton] graph] != NULL) {
            ((VitalSign*)[self.object_list objectAtIndex:(indexOfClickedButton)]).isSelected = ![[self.object_list objectAtIndex:(indexOfClickedButton)] isSelected];
        }
        else {
            bool tempIsSelected = ![[self.object_list objectAtIndex:(indexOfClickedButton)] isSelected];
            for (int i = 0; i < [self.object_list count]; i++) {
                if ([[self.object_list objectAtIndex:i] graph] == NULL) {
                    ((VitalSign*)[self.object_list objectAtIndex:i]).isSelected = tempIsSelected;
                }
            }
        }
    }
    else {
        if ([[self.object_list objectAtIndex:indexOfClickedButton] graph] != NULL) {
            ((VitalSign*)[self.object_list objectAtIndex:(indexOfClickedButton)]).isSelected2 = ![[self.object_list objectAtIndex:(indexOfClickedButton)] isSelected2];
        }
        else {
            bool tempIsSelected = ![[self.object_list objectAtIndex:(indexOfClickedButton)] isSelected2];
            for (int i = 0; i < [self.object_list count]; i++) {
                if ([[self.object_list objectAtIndex:i] graph] == NULL) {
                    ((VitalSign*)[self.object_list objectAtIndex:i]).isSelected2 = tempIsSelected;
                }
            }
        }
    }
    
    // This will actually handle resizing the views
    [self sizeViews:self.object_list];
    
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Resizes the view heights so that the clicked has double height than the rest
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (IBAction)handleAlarmAction:(id)sender {
    UIButton *buttonClicked = (UIButton *)sender;
    
    // This next for loop checks to see which button is expanded...
    int indexOfClickedButton = 0;
    for (int i = 0; i < [self.object_list count]; i++) {
        if ([[[self.object_list objectAtIndex:i] alarm] isEqual:buttonClicked]) {
            indexOfClickedButton = i;
            break;
        }
    }
    
    
    if ([[self.object_list objectAtIndex:indexOfClickedButton] alarmVC] == nil) {
        // Create the AlarmViewController.
        ((VitalSign*)[self.object_list objectAtIndex:indexOfClickedButton]).alarmVC = [[AlarmViewController alloc] initWithIndex:indexOfClickedButton];
        
        ([(VitalSign*)[self.object_list objectAtIndex:indexOfClickedButton] alarmVC]).delegate = self;

    }
    
    if (![[self.object_list objectAtIndex:indexOfClickedButton] alarmPopover].popoverVisible
            && [[self.object_list objectAtIndex:indexOfClickedButton] alarmPopover] != nil) {
        // The popover controller is not shown but has not been removed.
        ((VitalSign*)[self.object_list objectAtIndex:indexOfClickedButton]).alarmPopover = nil;
    }
    
    if ([[self.object_list objectAtIndex:indexOfClickedButton] alarmPopover] == nil) {
        // The alarm popover is not showing. Show it.
        ((VitalSign*)[self.object_list objectAtIndex:indexOfClickedButton]).alarmPopover = [[UIPopoverController alloc] initWithContentViewController:[[self.object_list objectAtIndex:indexOfClickedButton] alarmVC]];
        [[[self.object_list objectAtIndex:indexOfClickedButton] alarmPopover] presentPopoverFromRect:buttonClicked.frame inView:self.view permittedArrowDirections:UIPopoverArrowDirectionDown animated:YES];
        
    }
    else {
        // The alarm popover is showing. Hide it.
        [[[self.object_list objectAtIndex:indexOfClickedButton] alarmPopover] dismissPopoverAnimated:YES];
        ((VitalSign*)[self.object_list objectAtIndex:indexOfClickedButton]).alarmVC = nil;
        ((VitalSign*)[self.object_list objectAtIndex:indexOfClickedButton]).alarmPopover = nil;
    }
    
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Resizes the view heights so that the clicked has double height than the rest
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)selectedAlarmOfObjectIndex:(int)objectIndex withMax:(float)max andMin:(float)min {
    NSLog(@"Max = %f",max);
    NSLog(@"Min = %f",min);
    
    ((VitalSign*)[self.object_list objectAtIndex:objectIndex]).maxAlarm = max;
    ((VitalSign*)[self.object_list objectAtIndex:objectIndex]).minAlarm = min;
    
    // Dismiss the popover if it's showing.
    if ([[self.object_list objectAtIndex:objectIndex] alarmPopover]) {
        [[[self.object_list objectAtIndex:objectIndex] alarmPopover] dismissPopoverAnimated:YES];
        ((VitalSign*)[self.object_list objectAtIndex:objectIndex]).alarmPopover = nil;
    }
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
