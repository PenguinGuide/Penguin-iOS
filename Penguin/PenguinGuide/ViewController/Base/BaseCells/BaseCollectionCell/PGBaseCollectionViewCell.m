//
//  PGBaseCollectionViewCell.m
//  Penguin
//
//  Created by Kobe Dai on 04/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGBaseCollectionViewCell.h"

@implementation PGBaseCollectionViewCell

- (void)insertCellBorderLayer:(CGFloat)cornerRadius
{
    CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
    maskShapeLayer.frame = CGRectMake(0, 0, self.pg_width, self.pg_height);
    
    CAShapeLayer *borderShapeLayer = [CAShapeLayer layer];
    borderShapeLayer.frame = CGRectMake(0, 0, self.pg_width, self.pg_height);
    borderShapeLayer.lineWidth = 1.f;
    borderShapeLayer.strokeColor = Theme.colorBackground.CGColor;
    borderShapeLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.pg_width, self.pg_height) cornerRadius:cornerRadius];
    maskShapeLayer.path = bezierPath.CGPath;
    borderShapeLayer.path = bezierPath.CGPath;
    
    [self.contentView.layer insertSublayer:borderShapeLayer atIndex:0];
    [self.layer setMask:maskShapeLayer];
}

- (void)insertCellMask:(CGFloat)cornerRadius
{
    CAShapeLayer *maskShapeLayer = [CAShapeLayer layer];
    maskShapeLayer.frame = CGRectMake(0, 0, self.pg_width, self.pg_height);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.pg_width, self.pg_height) cornerRadius:cornerRadius];
    maskShapeLayer.path = bezierPath.CGPath;
    
    // NOTE: [self.contentView.layer setMask:maskShapeLayer] will not work
    [self.layer setMask:maskShapeLayer];
}

@end
