//
//  PGBaseCollectionViewFooterView.m
//  Penguin
//
//  Created by Jing Dai on 24/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseCollectionViewFooterView.h"

@implementation PGBaseCollectionViewFooterView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
        UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.pg_width-98)/2, 30, 98, 42)];
        imageView.image = [UIImage imageNamed:@"pg_collection_view_footer_view"];
        [self addSubview:imageView];
    }
    return self;
}

+ (CGSize)footerViewSize
{
    return CGSizeMake(UISCREEN_WIDTH, 30+42+32);
}

@end
