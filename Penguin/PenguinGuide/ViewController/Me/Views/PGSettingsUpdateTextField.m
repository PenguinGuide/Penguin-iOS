//
//  PGSettingsUpdateTextField.m
//  Penguin
//
//  Created by Jing Dai on 24/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSettingsUpdateTextField.h"

@implementation PGSettingsUpdateTextField

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
    self.backgroundColor = [UIColor clearColor];
    self.textColor = Theme.colorText;
    self.font = Theme.fontSmallBold;
    self.returnKeyType = UIReturnKeyDone;
    
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.pg_height-1/[UIScreen mainScreen].scale, self.pg_width, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = Theme.colorText;
    [self addSubview:horizontalLine];
}

- (BOOL)canPerformAction:(SEL)action withSender:(id)sender
{
    return NO;
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder) {
        NSAttributedString *attrPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                              attributes:@{NSFontAttributeName:Theme.fontSmallBold,
                                                                                           NSForegroundColorAttributeName:Theme.colorLightText}];
        self.attributedPlaceholder = attrPlaceholder;
    }
}

@end
