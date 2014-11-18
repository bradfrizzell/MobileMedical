//
//  Graph.m
//  PatientMonitor
//
//  Created by Alex Henry on 11/13/14.
//  Copyright (c) 2014 Alexander Henry. All rights reserved.
//

#import "Graph.h"

@interface Graph ()

@property (nonatomic, assign) CGFloat xScale;
@property (nonatomic, assign) CGFloat yScale;
@property (nonatomic, assign) NSInteger plotStep;
@property UIColor *axisColor;
@property UIColor *plotColor;

@end

@implementation Graph


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSMutableArray *) graphXData
{
    if (!_graphXData){
        _graphXData = [[NSMutableArray alloc] init];
    }
    
    return _graphXData;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (NSMutableArray *) graphYData
{
    if (!_graphYData){
        _graphYData = [[NSMutableArray alloc] init];
    }
    
    return _graphYData;
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void) drawAxisX
{
    CGPoint start = CGPointMake(0, self.frame.size.height/2);
    CGPoint end = CGPointMake(self.frame.size.width, self.frame.size.height/2);
    
    UIBezierPath *axisX = [[UIBezierPath alloc] init];
    [self.axisColor setStroke];
    axisX.lineWidth = 1.0;
    [axisX moveToPoint: start];
    [axisX addLineToPoint: end];
    [axisX stroke];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void) drawAxisY
{
    CGPoint start = CGPointMake(0, 0);
    CGPoint end = CGPointMake(0, self.frame.size.height);
    
    UIBezierPath *axisY = [[UIBezierPath alloc] init];
    [self.axisColor setStroke];
    axisY.lineWidth = 3.0;
    [axisY moveToPoint: start];
    [axisY addLineToPoint:end];
    [axisY stroke];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)setFrame:(CGRect)rect {

    [super setFrame:rect];
    
    self.yScale = self.frame.size.height/2;
    self.xScale = self.frame.size.width/self.num_data;

}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void)myInitialization
{
    // Initialization code
    self.backgroundColor = [UIColor blackColor];
    self.axisColor = [UIColor whiteColor];
    self.yScale = self.frame.size.height/5;
    self.plotStep = 0;
    self.num_data = 400; //
    self.xScale = self.frame.size.width/self.num_data;
    self.num_points = self.num_data-20; // Number of points on the screen at a time
    //NSLog(@"width is %f",self.frame.size.width);
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)initWithCoder:(NSCoder*)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if (self)
    {
        [self myInitialization];
    }
    
    return self;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        [self myInitialization];
    }
    return self;
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
/*- (void) AnimatedPlacePoint
{
    NSArray *ax = [self.graphXData copy];
    NSArray *ay = [self.graphYData copy];

    NSMutableArray *paths = [[NSMutableArray alloc] init];
    
    [NSTimer scheduledTimerWithTimeInterval:.001 target:self selector:@selector(goTime:) userInfo:nil repeats:YES];
    

    UIBezierPath *gPath = [UIBezierPath bezierPath];
    CGPoint pa = CGPointMake([ax[(self.plotStep)%self.num_data] floatValue], [ay[(self.plotStep)%self.num_data] floatValue]);
    CGPoint ra = [self scalePoint2:pa];
    [gPath moveToPoint:ra]; //
    
    float last_x_value=0;
    for (NSInteger i = 0; i < self.num_points; ++i) {
        if (last_x_value>[ax[(self.plotStep+i)%self.num_data] floatValue]){
            // The point of this if block is to direct the line around the bounds
            // of the graph when the graph runs to the right edge. This is because the
            // bezier curve has to be one continuous line, so otherwise the line
            // would cut back through the middle of the graph. This can be verified
            // by commenting out this entire if block.
            

            pa = CGPointMake(self.frame.size.width+100, 0);
            [gPath addCurveToPoint:pa controlPoint1:pa controlPoint2:pa];
            
            pa = CGPointMake(self.frame.size.width+100, self.frame.size.height + 100);
            [gPath addCurveToPoint:pa controlPoint1:pa controlPoint2:pa];
            
            pa = CGPointMake(-100, self.frame.size.height + 100);
            [gPath addCurveToPoint:pa controlPoint1:pa controlPoint2:pa];
            
            pa = CGPointMake(-100, 100) ;
            [gPath addCurveToPoint:pa controlPoint1:pa controlPoint2:pa];
        }
        pa = CGPointMake([ax[(self.plotStep+i)%self.num_data] floatValue], [ay[(self.plotStep+i)%self.num_data] floatValue]);
        ra = [self scalePoint2:pa];
        [gPath addCurveToPoint:ra controlPoint1:ra controlPoint2:ra];
        last_x_value =[ax[(self.plotStep+i)%self.num_data] floatValue];
    }

    gPath.lineWidth = 1;
    [self.plotColor setStroke];
    [gPath stroke];
    [paths addObject:gPath];
    [gPath removeAllPoints];

}*/

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void) AnimatedPlacePoint
{
    NSArray *ax = [self.graphXData copy];
    NSArray *ay = [self.graphYData copy];

    [NSTimer scheduledTimerWithTimeInterval:-1 target:self selector:@selector(goTime:) userInfo:nil repeats:YES];

    BOOL left_point_placed = false;
    
    UIBezierPath *rightPath = [UIBezierPath bezierPath]; // Right path is the path on the right side of the screen
    UIBezierPath *leftPath = [UIBezierPath bezierPath]; // Left path is on the left side of the screen, only
    
    // when the rightPath has gotten all the way to the edge of the screen
    CGPoint pa = CGPointMake([ax[(self.plotStep)%self.num_data] floatValue],
                             [ay[(self.plotStep)%self.num_data] floatValue]);
    CGPoint ra = [self scalePoint2:pa];
    [rightPath moveToPoint:ra];
    float last_x_value=0;

    [self.plotColor setStroke];
    [rightPath stroke];
    [leftPath stroke];

    for (NSInteger i = 0; i < self.num_points; ++i) {
        if (left_point_placed == false){
            // If the only graph on the screen is the right path
            if (last_x_value>[ax[(self.plotStep+i)%self.num_data] floatValue]){
                // If the right path has reached the right edge of the graph's frame,
                // then we must begin printing future points from the left side, so
                // we need to use a different path, i.e. the 'leftPath'
                left_point_placed = true;
                pa = CGPointMake([ax[(self.plotStep+i)%self.num_data] floatValue],
                                 [ay[(self.plotStep+i)%self.num_data] floatValue]);
                ra = [self scalePoint2:pa];
                [leftPath moveToPoint:ra];
                left_point_placed = true;
                [leftPath addCurveToPoint:ra controlPoint1:ra controlPoint2:ra];
                last_x_value =[ax[(self.plotStep+i)%self.num_data] floatValue];
            }
            else {
                pa = CGPointMake([ax[(self.plotStep+i)%self.num_data] floatValue],
                                 [ay[(self.plotStep+i)%self.num_data] floatValue]);
                ra = [self scalePoint2:pa];
                [rightPath addCurveToPoint:ra controlPoint1:ra controlPoint2:ra];
                last_x_value =[ax[(self.plotStep+i)%self.num_data] floatValue];}
        }
        else {
            pa = CGPointMake([ax[(self.plotStep+i)%self.num_data] floatValue],
                             [ay[(self.plotStep+i)%self.num_data] floatValue]);
            ra = [self scalePoint2:pa];
            [leftPath addCurveToPoint:ra controlPoint1:ra controlPoint2:ra];
            last_x_value =[ax[(self.plotStep+i)%self.num_data] floatValue];
        }
    }
    
    rightPath.lineWidth = 1;
    leftPath.lineWidth = 1;
    [self.plotColor setStroke];
    [rightPath stroke];
    [leftPath stroke];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void) setGraphColor:(UIColor*)color {
    self.plotColor = color;
    //self.scaleY = self.scaleY/2;
}


//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (void) goTime: (NSTimer *) timer
{
    //NSLog(@"%s", __FUNCTION__);
    
    self.plotStep = (self.plotStep + 1)%self.num_data;
    //NSLog(@"Timer");
    [timer invalidate];
    [self setNeedsDisplay];
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
- (CGPoint) scalePoint2: (CGPoint) data

{
    
    CGFloat plotY = (data.y*self.yScale + self.frame.size.height/2);
    CGFloat plotX = (data.x*self.xScale);
    
    return CGPointMake(plotX, plotY);
}

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    [self drawAxisX];
    [self drawAxisY];
    [self AnimatedPlacePoint];
    
}


@end