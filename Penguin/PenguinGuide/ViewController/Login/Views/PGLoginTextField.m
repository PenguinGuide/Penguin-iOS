//
//  PGLoginTextField.m
//  Penguin
//
//  Created by Jing Dai on 11/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginTextField.h"

@implementation PGLoginTextField

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
    self.textColor = [UIColor whiteColor];
    self.font = Theme.fontSmallBold;
    self.returnKeyType = UIReturnKeyDone;
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.pg_height-1/[UIScreen mainScreen].scale, self.pg_width, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = [UIColor whiteColor];
    [self addSubview:horizontalLine];
}

- (void)setPlaceholder:(NSString *)placeholder
{
    if (placeholder) {
        NSAttributedString *attrPlaceholder = [[NSAttributedString alloc] initWithString:placeholder
                                                                              attributes:@{NSFontAttributeName:Theme.fontSmallBold,
                                                                                           NSForegroundColorAttributeName:[UIColor whiteColor]}];
        self.attributedPlaceholder = attrPlaceholder;
    }
}

@end
