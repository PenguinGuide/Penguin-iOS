//
//  PGArticleParagraphFooterCell.m
//  Penguin
//
//  Created by Jing Dai on 9/20/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleParagraphFooterCell.h"

@implementation PGArticleParagraphFooterCell

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
    UILabel *topLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.pg_width-180)/2, 30, 180, 22)];
    topLabel.backgroundColor = [UIColor colorWithHexString:@"FEE500"];
    topLabel.font = Theme.fontSmallBold;
    topLabel.textColor = Theme.colorText;
    topLabel.textAlignment = NSTextAlignmentCenter;
    topLabel.text = @"企鹅出品，未经允许不得转载";
    
    UILabel *bottomLabel = [[UILabel alloc] initWithFrame:CGRectMake((self.pg_width-180)/2, 52, 180, 22)];
    bottomLabel.backgroundColor = [UIColor colorWithHexString:@"FEE500"];
    bottomLabel.font = Theme.fontSmallBold;
    bottomLabel.textColor = Theme.colorText;
    bottomLabel.textAlignment = NSTextAlignmentCenter;
    bottomLabel.text = @"更多精彩阅读，请滑动下方";
    
    [self.contentView addSubview:topLabel];
    [self.contentView addSubview:bottomLabel];
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.pg_width-196)/2, bottomLabel.pg_bottom+50, 196, 20)];
    imageView.image = [UIImage imageNamed:@"pg_article_footer_separator"];
    [self.contentView addSubview:imageView];
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, 30+22+22+50+20+20);
}

@end
