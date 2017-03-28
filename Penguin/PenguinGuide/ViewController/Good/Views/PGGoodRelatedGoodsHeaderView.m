//
//  PGGoodRelatedGoodsHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 08/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGoodRelatedGoodsHeaderView.h"

@implementation PGGoodRelatedGoodsHeaderView

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
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
    label.text = @"· 推荐商品 ·";
    label.font = Theme.fontMediumBold;
    label.textColor = Theme.colorText;
    label.textAlignment = NSTextAlignmentCenter;
    [self addSubview:label];
}

@end
