//
//  PGCityGuideSegmentIndicator.m
//  Penguin
//
//  Created by Jing Dai on 28/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCityGuideSegmentIndicator.h"

@implementation PGCityGuideSegmentIndicator

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetLineWidth(context, 1.f);
    CGContextSetStrokeColorWithColor(context, Theme.colorExtraHighlight.CGColor);
    
    CGContextMoveToPoint(context, 1, self.pg_height-1);
    CGContextAddLineToPoint(context, 4, 1);
    CGContextMoveToPoint(context, self.pg_width-4, self.pg_height-1);
    CGContextAddLineToPoint(context, self.pg_width-1, 1);
    
    CGContextDrawPath(context, kCGPathFillStroke);
}

@end
