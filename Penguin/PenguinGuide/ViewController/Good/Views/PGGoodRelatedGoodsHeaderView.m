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
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.pg_width/2-117/2.f, 15, 117, 14)];
    imageView.image = [UIImage imageNamed:@"pg_good_related_goods_header"];
    [self addSubview:imageView];
}

@end
