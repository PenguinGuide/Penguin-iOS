//
//  PGSearchTextField.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchTextField.h"

@implementation PGSearchTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    UIView *paddingView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 15, 30)];
    paddingView.backgroundColor = [UIColor clearColor];
    [self setLeftViewMode:UITextFieldViewModeAlways];
    [self setClearButtonMode:UITextFieldViewModeAlways];
    [self setLeftView:paddingView];
    [self setTintColor:Theme.colorExtraHighlight];
    [self setFont:Theme.fontSmallBold];
    [self setTextColor:Theme.colorText];
    [self setBackground:[UIImage imageNamed:@"pg_search_textfield_bg"]];
}

@end
