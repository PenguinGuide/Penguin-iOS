//
//  PGDashedLineView.m
//  Penguin
//
//  Created by Jing Dai on 9/20/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGDashedLineView.h"

@implementation PGDashedLineView

- (void)drawRect:(CGRect)rect
{
    [super drawRect:rect];
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextBeginPath(context);
    CGContextSetLineWidth(context, 2.f);
    CGContextSetStrokeColorWithColor(context, Theme.colorText.CGColor);
    CGFloat lengths[] = {5, 5};
    CGContextSetLineDash(context, 0, lengths, 2);
    CGContextMoveToPoint(context, 0, 0);
    CGContextAddLineToPoint(context, rect.size.width, 0);
    CGContextStrokePath(context);
}

@end
