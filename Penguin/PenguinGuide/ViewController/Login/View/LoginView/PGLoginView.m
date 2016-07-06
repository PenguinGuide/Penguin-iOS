//
//  PGLoginView.m
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginView.h"

@interface PGLoginView ()

@property (nonatomic, strong, readwrite) UIButton *nextButton;

@end

@implementation PGLoginView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.nextButton];
    }
    
    return self;
}

- (UIButton *)nextButton
{
    if (!_nextButton) {
        if (DEVICE_IS_LESS_OR_EQUAL_TO_IPHONE_5) {
            _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.frame.size.height-22-30, self.frame.size.width-26*2, 30)];
        } else {
            _nextButton = [[UIButton alloc] initWithFrame:CGRectMake(26, self.frame.size.height-22-45, self.frame.size.width-26*2, 45)];
        }
        [_nextButton setBackgroundColor:[UIColor blackColor]];
        [_nextButton setTitle:@"下 一 步" forState:UIControlStateNormal];
        [_nextButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_nextButton.titleLabel setFont:Theme.fontMedium];
    }
    return _nextButton;
}

@end
