//
//  PGStoreCategoryCell.m
//  Penguin
//
//  Created by Kobe Dai on 20/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGStoreScenarioCell.h"
#import "PGScenarioBanner.h"

@interface PGStoreScenarioCell ()

@property (nonatomic, strong) UIImageView *categoryImageView;
@property (nonatomic, strong) UILabel *categoryTitleLabel;

@end

@implementation PGStoreScenarioCell

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
    [self.contentView addSubview:self.categoryImageView];
    [self.contentView addSubview:self.categoryTitleLabel];
}

- (void)setCellWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGScenarioBanner class]]) {
        PGScenarioBanner *scenarioBanner = (PGScenarioBanner *)model;
        [self.categoryImageView setWithImageURL:scenarioBanner.image imageSize:CGSizeMake(82*2.5, 82*2.5) placeholder:nil completion:nil];
        
        if (scenarioBanner.title) {
            CGSize textSize = [scenarioBanner.title sizeWithAttributes:@{NSFontAttributeName:Theme.fontExtraSmall}];
            self.categoryTitleLabel.frame = CGRectMake(6, 6, textSize.width+8, 20);
            [self.categoryTitleLabel setText:scenarioBanner.title];
            [self.categoryTitleLabel cropCornerRadius:4.f];
        }
    }
}

+ (CGSize)cellSize
{
    return CGSizeMake(82, 82);
}

- (UIImageView *)categoryImageView
{
    if (!_categoryImageView) {
        _categoryImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
        _categoryImageView.backgroundColor = Theme.colorBackground;
        _categoryImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_categoryImageView cropCornerRadius:4.f];
    }
    return _categoryImageView;
}

- (UILabel *)categoryTitleLabel
{
    if (!_categoryTitleLabel) {
        _categoryTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _categoryTitleLabel.backgroundColor = [UIColor blackColor];
        _categoryTitleLabel.font = Theme.fontExtraSmall;
        _categoryTitleLabel.textAlignment = NSTextAlignmentCenter;
        _categoryTitleLabel.textColor = [UIColor whiteColor];
    }
    return _categoryTitleLabel;
}

@end
