//
//  PGSegmentedButtonsControl.m
//  Penguin
//
//  Created by Kobe Dai on 28/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGSegmentedButtonsControl.h"

@interface PGSegmentedButtonsControl ()

@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, assign) CGSize buttonSize;

@end

@implementation PGSegmentedButtonsControl

+ (PGSegmentedButtonsControl *)segmentedButtonsControlWithTitles:(NSArray *)titles images:(NSArray *)images segmentedButtonSize:(CGSize)buttonSize
{
    NSAssert((titles.count == images.count && titles.count != 0 && images.count != 0), @"titles' count is not equal to images' count");
    
    CGFloat controlWidth = buttonSize.width*titles.count;
    PGSegmentedButtonsControl *segmentedButtonsControl = [[PGSegmentedButtonsControl alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-controlWidth)/2, UISCREEN_HEIGHT-50-buttonSize.height, controlWidth, buttonSize.height)];
    segmentedButtonsControl.backgroundColor = [UIColor clearColor];
    segmentedButtonsControl.titles = titles;
    segmentedButtonsControl.images = images;
    segmentedButtonsControl.buttonSize = buttonSize;
    
    return segmentedButtonsControl;
}

- (void)drawRect:(CGRect)rect
{
    [self.layer.sublayers makeObjectsPerformSelector:@selector(removeFromSuperlayer)];
    
    __block CAShapeLayer *containerLayer = [CAShapeLayer layer];
    containerLayer.frame = CGRectMake(0, 0, rect.size.width, rect.size.height);
    containerLayer.fillColor = [UIColor whiteColor].CGColor;
    containerLayer.shadowColor = Theme.colorLightText.CGColor;
    containerLayer.shadowOpacity = 0.7f;
    containerLayer.shadowRadius = 1.f;
    containerLayer.shadowOffset = CGSizeMake(0, 1.f);
    
    UIBezierPath *containerBeizerPath = [UIBezierPath bezierPathWithRoundedRect:containerLayer.frame cornerRadius:rect.size.height/2];
    containerLayer.path = containerBeizerPath.CGPath;
    
    PGWeakSelf(self);
    __block CGFloat x = 0;
    [self.titles enumerateObjectsUsingBlock:^(NSString *title, NSUInteger idx, BOOL * _Nonnull stop) {
        UIImage *image = weakself.images[idx];
        CALayer *iconLayer = [CALayer layer];
        iconLayer.frame = CGRectMake(x+(weakself.buttonSize.width-20)/2, 8, 20, 20);
        iconLayer.contents = (__bridge id)image.CGImage;
        
        CATextLayer *textLayer = [CATextLayer layer];
        textLayer.frame = CGRectMake(x, rect.size.height-5-12, weakself.buttonSize.width, 12);
        textLayer.string = [[NSAttributedString alloc] initWithString:title attributes:@{NSFontAttributeName:Theme.fontExtraSmallLight, NSForegroundColorAttributeName:Theme.colorGrayText}];
        textLayer.alignmentMode = kCAAlignmentCenter;
        textLayer.contentsScale = [UIScreen mainScreen].scale;
        
        x = x + weakself.buttonSize.width;
        
        [containerLayer addSublayer:iconLayer];
        [containerLayer addSublayer:textLayer];
        
        if (idx < weakself.titles.count-1) {
            CALayer *horizontalLineLayer = [CALayer layer];
            horizontalLineLayer.frame = CGRectMake(weakself.buttonSize.width*(idx+1), 10, 1.f, weakself.buttonSize.height-20);
            horizontalLineLayer.backgroundColor = Theme.colorBorder.CGColor;
            [containerLayer addSublayer:horizontalLineLayer];
        }
    }];
    
    [self.layer addSublayer:containerLayer];
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    NSInteger index = location.x / self.buttonSize.width;
    
    if (self.indexClickedBlock) {
        self.indexClickedBlock(index);
    }
}

@end
