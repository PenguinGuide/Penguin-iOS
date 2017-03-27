//
//  PGCoverTagView.m
//  Penguin
//
//  Created by Kobe Dai on 27/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGCoverTagView.h"

@interface PGCoverTagView ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, assign) CGPoint margin;
@property (nonatomic, assign) PGCoverTagViewAlignment alignment;
@property (nonatomic, assign) PGCoverTagViewStyle style;

@end

@implementation PGCoverTagView

+ (PGCoverTagView *)tagViewWithMargin:(CGPoint)margin alignment:(PGCoverTagViewAlignment)alignment
{
    PGCoverTagView *tagView = [[PGCoverTagView alloc] init];
    tagView.margin = margin;
    tagView.alignment = alignment;
    tagView.backgroundColor = [UIColor clearColor];
    
    return tagView;
}

- (void)setTagViewWithTitle:(NSString *)title style:(PGCoverTagViewStyle)style
{
    self.title = title;
    self.style = style;
    
    CGSize titleSize = [title sizeWithAttributes:@{NSFontAttributeName:Theme.fontSmallLight}];
    if (self.alignment == PGCoverTagViewAlignmentLeft) {
        self.frame = CGRectMake(self.margin.x, self.margin.y, titleSize.width+12*2, 26);
    } else if (self.alignment == PGCoverTagViewAlignmentRight) {
        self.frame = CGRectMake(UISCREEN_WIDTH-self.margin.x-(titleSize.width+12*2), self.margin.y, titleSize.width+12*2, 26);
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    CATextLayer *textLayer = [CATextLayer layer];
    textLayer.frame = CGRectMake(12, 3, self.pg_width-12*2, self.pg_height-6);
    textLayer.string = [[NSAttributedString alloc] initWithString:self.title attributes:@{NSFontAttributeName:Theme.fontSmallLight, NSForegroundColorAttributeName:[UIColor whiteColor]}];
    textLayer.alignmentMode = kCAAlignmentCenter;
    textLayer.contentsScale = [[UIScreen mainScreen] scale];
    
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    shapeLayer.frame = CGRectMake(0, 0, self.pg_width, self.pg_height);
    if (self.style == PGCoverTagViewStyleNormal) {
        shapeLayer.fillColor = [UIColor blackColor].CGColor;
    } else if (self.style == PGCoverTagViewStyleHot) {
        shapeLayer.fillColor = [UIColor colorWithHexString:@"EF3333"].CGColor;
    } else if (self.style == PGCoverTagViewStyleNew) {
        shapeLayer.fillColor = Theme.colorExtraHighlight.CGColor;
    }
    
    UIBezierPath *shapeBezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.pg_width, self.pg_height-6) cornerRadius:4.f];
    [shapeBezierPath moveToPoint:CGPointMake(self.pg_width/2+3, self.pg_height-6)];
    [shapeBezierPath addLineToPoint:CGPointMake(self.pg_width/2, self.pg_height)];
    [shapeBezierPath addLineToPoint:CGPointMake(self.pg_width/2-3, self.pg_height-6)];
    shapeLayer.path = shapeBezierPath.CGPath;
    
    [shapeLayer addSublayer:textLayer];
    [self.layer addSublayer:shapeLayer];
}

@end
