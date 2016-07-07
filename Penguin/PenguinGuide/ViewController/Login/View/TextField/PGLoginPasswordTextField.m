//
//  PGLoginPasswordTextField.m
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginPasswordTextField.h"

@implementation PGLoginPasswordTextField

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 38+12, frame.size.height)];
        self.leftView.backgroundColor = [UIColor colorWithHexString:@"e7e7e7"];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12, 11, 10, 20)];
        iconImageView.image = [UIImage imageNamed:@"pg_login_textfield_password"];
        [self.leftView addSubview:iconImageView];
        
        UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(38-1, 9, 1, frame.size.height-9*2)];
        verticalLine.backgroundColor = [UIColor blackColor];
        [self.leftView addSubview:verticalLine];
        
        self.backgroundColor = [UIColor colorWithHexString:@"e7e7e7"];
        
        self.textColor = [UIColor blackColor];
        self.font = Theme.fontLarge;
        self.secureTextEntry = YES;
        
        self.placeholder = @"请输入密码";
    }
    
    return self;
}

@end
