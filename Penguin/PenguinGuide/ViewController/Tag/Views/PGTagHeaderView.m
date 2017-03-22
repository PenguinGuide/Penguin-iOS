//
//  PGTagHeaderView.m
//  Penguin
//
//  Created by Kobe Dai on 21/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGTagHeaderView.h"
#import "SDWebImageManager.h"

@implementation PGTagHeaderView

+ (PGTagHeaderView *)headerViewWithImageView:(UIImageView *)imageView title:(NSString *)title desc:(NSString *)desc
{
    PGTagHeaderView *tagHeaderView = [[PGTagHeaderView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*9/16+93+10-14)];
    tagHeaderView.backgroundColor = [UIColor whiteColor];
    
    [tagHeaderView addSubview:imageView];
    
    UILabel *tagTitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, UISCREEN_WIDTH*9/16-14, UISCREEN_WIDTH, 42)];
    tagTitleLabel.font = [UIFont systemFontOfSize:30.f weight:UIFontWeightBold];
    tagTitleLabel.textColor = Theme.colorText;
    tagTitleLabel.text = title;
    tagTitleLabel.textAlignment = NSTextAlignmentCenter;
    [tagHeaderView addSubview:tagTitleLabel];
    CGFloat tagTitleLabelBottomDistance = tagHeaderView.pg_height-tagTitleLabel.pg_bottom;
    [tagTitleLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(42);
        make.bottom.mas_equalTo(tagHeaderView.mas_bottom).mas_equalTo(-tagTitleLabelBottomDistance);
    }];
    
    UILabel *tagDescLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, tagTitleLabel.pg_bottom+25, UISCREEN_WIDTH, 20)];
    tagDescLabel.font = Theme.fontMedium;
    tagDescLabel.textColor = Theme.colorText;
    tagDescLabel.text = desc;
    tagDescLabel.textAlignment = NSTextAlignmentCenter;
    [tagHeaderView addSubview:tagDescLabel];
    [tagDescLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(0);
        make.right.mas_equalTo(0);
        make.height.mas_equalTo(20);
        make.top.mas_equalTo(tagTitleLabel.mas_bottom).mas_equalTo(25);
    }];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(30, tagHeaderView.pg_height-SINGLE_LINE_HEIGHT, UISCREEN_WIDTH-60, SINGLE_LINE_HEIGHT)];
    horizontalLine.backgroundColor = Theme.colorBackground;
    [tagHeaderView addSubview:horizontalLine];
    [horizontalLine mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(30);
        make.right.mas_equalTo(-30);
        make.height.mas_equalTo(SINGLE_LINE_HEIGHT);
        make.bottom.mas_equalTo(-SINGLE_LINE_HEIGHT);
    }];
    
    return tagHeaderView;
}

@end
