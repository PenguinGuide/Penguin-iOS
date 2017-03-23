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

@property (nonatomic, strong) UIImageView *scenarioImageView;
@property (nonatomic, strong) UILabel *scenarioTitleLabel;

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
    [self.contentView addSubview:self.scenarioImageView];
    [self.contentView addSubview:self.scenarioTitleLabel];
}

- (void)setCellWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGScenarioBanner class]]) {
        PGScenarioBanner *scenarioBanner = (PGScenarioBanner *)model;
        [self.scenarioImageView setWithImageURL:scenarioBanner.image imageSize:CGSizeMake(82*2.5, 82*2.5) placeholder:nil completion:nil];
        
        if (scenarioBanner.title) {
            CGSize textSize = [scenarioBanner.title sizeWithAttributes:@{NSFontAttributeName:Theme.fontExtraSmall}];
            self.scenarioTitleLabel.frame = CGRectMake(6, 6, textSize.width+8, 20);
            [self.scenarioTitleLabel setText:scenarioBanner.title];
            [self.scenarioTitleLabel cropCornerRadius:4.f];
        }
    }
}

- (void)cellDidSelectWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGScenarioBanner class]]) {
        PGScenarioBanner *scenarioBanner = (PGScenarioBanner *)model;
        [PGRouterManager routeToScenarioPage:scenarioBanner.scenarioId link:scenarioBanner.link fromStorePage:YES];
    }
}

+ (CGSize)cellSize
{
    return CGSizeMake(82, 82);
}

- (UIImageView *)scenarioImageView
{
    if (!_scenarioImageView) {
        _scenarioImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_height)];
        _scenarioImageView.backgroundColor = Theme.colorBackground;
        _scenarioImageView.contentMode = UIViewContentModeScaleAspectFill;
        [_scenarioImageView cropCornerRadius:4.f];
    }
    return _scenarioImageView;
}

- (UILabel *)scenarioTitleLabel
{
    if (!_scenarioTitleLabel) {
        _scenarioTitleLabel = [[UILabel alloc] initWithFrame:CGRectZero];
        _scenarioTitleLabel.backgroundColor = [UIColor blackColor];
        _scenarioTitleLabel.font = Theme.fontExtraSmall;
        _scenarioTitleLabel.textAlignment = NSTextAlignmentCenter;
        _scenarioTitleLabel.textColor = [UIColor whiteColor];
    }
    return _scenarioTitleLabel;
}

@end
