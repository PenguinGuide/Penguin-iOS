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
@property (nonatomic, assign) CGSize imageSize;
@property (nonatomic, assign) NSInteger count;

@property (nonatomic, strong) UILabel *toolButtonTitleLabel;

@end

@implementation PGArticleToolButton

+ (PGArticleToolButton *)toolButtonWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image imageSize:(CGSize)imageSize count:(NSInteger)count
{
    PGArticleToolButton *button = [[PGArticleToolButton alloc] initWithFrame:frame];
    button.title = title;
    button.image = image;
    button.imageSize = imageSize;
    button.count = count;
    
    [button initialize];
    
    return button;
}

- (void)initialize
{
    [self addSubview:self.toolButtonTitleLabel];
    
    [self.toolButtonTitleLabel setText:self.title];
    [self setImage:self.image forState:UIControlStateNormal];
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
        _toolButtonTitleLabel.highlightedTextColor = Theme.colorExtraHighlight;
        _toolButtonTitleLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _toolButtonTitleLabel;
}

@end
