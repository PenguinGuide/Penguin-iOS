//
//  PGLoginInfoTextField.m
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginUserInfoTextField.h"

@implementation PGLoginUserInfoTextField

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.leftViewMode = UITextFieldViewModeAlways;
        self.leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12, 48)];
        
        self.backgroundColor = [UIColor colorWithHexString:@"e7e7e7"];
        
        self.textColor = [UIColor blackColor];
        self.font = Theme.fontLarge;
    }
    return self;
}

@end
