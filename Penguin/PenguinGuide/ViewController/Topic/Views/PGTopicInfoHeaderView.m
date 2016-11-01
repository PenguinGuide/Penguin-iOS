//
//  PGTopicHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 14/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTopicInfoHeaderView.h"

@interface PGTopicInfoHeaderView ()

@property (nonatomic, strong) UIImageView *headerImageView;
@property (nonatomic, strong) UILabel *descLabel;

@end

@implementation PGTopicInfoHeaderView

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
    [self addSubview:self.headerImageView];
    [self addSubview:self.descLabel];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(13, self.pg_height-1/[UIScreen mainScreen].scale, self.pg_width-26, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
    [self addSubview:horizontalLine];
}

- (void)setHeaderViewWithImage:(NSString *)image desc:(NSString *)desc
{
    [self.headerImageView setWithImageURL:image placeholder:nil completion:nil];
    
    CGSize textSize = [desc boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-26, 1000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:Theme.fontSmallBold}
                                         context:nil].size;
    self.descLabel.pg_height = textSize.height;
    self.descLabel.text = desc;
}

+ (CGSize)headerViewSize:(NSString *)desc
{
    CGSize textSize = [desc boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-26, 1000)
                                         options:NSStringDrawingUsesLineFragmentOrigin
                                      attributes:@{NSFontAttributeName:Theme.fontSmallBold}
                                         context:nil].size;
    return CGSizeMake(UISCREEN_WIDTH, UISCREEN_WIDTH*9/16+15+textSize.height+15+1/[UIScreen mainScreen].scale);
}

- (UIImageView *)headerImageView
{
    if (!_headerImageView) {
        _headerImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_width*9/16)];
        _headerImageView.clipsToBounds = YES;
        _headerImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _headerImageView;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(13, self.pg_width*9/16+15, self.pg_width-26, 0)];
        _descLabel.numberOfLines = 0;
        _descLabel.textColor = Theme.colorLightText;
        _descLabel.font = Theme.fontSmallBold;
    }
    return _descLabel;
}

@end
