//
//  PGArticleToolButton.m
//  Penguin
//
//  Created by Kobe Dai on 24/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGArticleToolButton.h"

@interface PGArticleToolButton ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) UIImage *image;
@property (nonatomic, strong) UIImage *highlightedImage;
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, strong) NSString *countStr;

@property (nonatomic, strong) UILabel *toolButtonTitleLabel;

@end

@implementation PGArticleToolButton

+ (PGArticleToolButton *)toolButtonWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage imageSize:(CGSize)imageSize count:(NSInteger)count
{
    PGArticleToolButton *button = [[PGArticleToolButton alloc] initWithFrame:frame];
    button.title = title;
    button.image = image;
    button.highlightedImage = highlightedImage;
    button.imageSize = imageSize;
    if (count <= 0) {
        button.countStr = @"";
    } else {
        if (count > 999) {
            button.countStr = @"999+";
        } else {
            button.countStr = [NSString stringWithFormat:@"%@", @(count)];
        }
    }
    
    [button initialize];
    
    return button;
}

- (void)initialize
{
    [self addSubview:self.toolButtonTitleLabel];
    
    [self.toolButtonTitleLabel setText:self.title];
    [self setImage:self.image forState:UIControlStateNormal];
}

- (void)updateCount:(NSInteger)count
{
    if (count <= 0) {
        self.countStr = @"";
    } else {
        if (count > 999) {
            self.countStr = @"999+";
        } else {
            self.countStr = [NSString stringWithFormat:@"%@", @(count)];
        }
    }
    
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect
{
    for (CALayer *sublayer in self.layer.sublayers) {
        if ([sublayer isKindOfClass:[CATextLayer class]]) {
            [sublayer removeFromSuperlayer];
        }
    }
    
    if (self.countStr && self.countStr.length > 0) {
        CATextLayer *countTextLayer = [CATextLayer layer];
        NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:self.countStr attributes:@{NSFontAttributeName:Theme.fontSmall,
                                                                                                          NSForegroundColorAttributeName:self.selected?Theme.colorExtraHighlight:Theme.colorLightText}];
        countTextLayer.frame = CGRectMake(self.imageView.pg_right+2, self.imageView.pg_top, attrS.size.width, 14);
        countTextLayer.string = attrS;
        countTextLayer.contentsScale = [UIScreen mainScreen].scale;
        
        [self.layer addSublayer:countTextLayer];
    }
}

- (CGRect)imageRectForContentRect:(CGRect)contentRect
{
    return CGRectMake((contentRect.size.width-self.imageSize.width)/2, 6, self.imageSize.width, self.imageSize.height);
}

- (UILabel *)toolButtonTitleLabel
{
    if (!_toolButtonTitleLabel) {
        _toolButtonTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.pg_height-6-10, self.pg_width, 10)];
        _toolButtonTitleLabel.font = Theme.fontExtraSmall;
        _toolButtonTitleLabel.textColor = Theme.colorLightText;
        _toolButtonTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _toolButtonTitleLabel;
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    [self setImage:selected?self.highlightedImage:self.image forState:UIControlStateNormal];
    [self.toolButtonTitleLabel setTextColor:selected?Theme.colorExtraHighlight:Theme.colorLightText];
    
    [self setNeedsDisplay];
}

@end
