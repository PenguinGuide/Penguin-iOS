//
//  PGMeCell.m
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMeCell.h"

@interface PGMeCell ()

@property (nonatomic, strong) UIImageView *iconImageView;
@property (nonatomic, strong) UILabel *nameLabel;
@property (nonatomic, strong) UIView *dotView;

@end

@implementation PGMeCell

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
    [self.contentView addSubview:self.iconImageView];
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dotView];
}

- (void)setCellWithName:(NSString *)name icon:(NSString *)icon highlight:(BOOL)highlight
{
    self.iconImageView.image = [UIImage imageNamed:icon];
    self.nameLabel.text = name;
    if (highlight) {
        self.dotView.hidden = NO;
    } else {
        self.dotView.hidden = YES;
    }
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, 60);
}

#pragma mark - <Lazy Init>

- (UIImageView *)iconImageView
{
    if (!_iconImageView) {
        _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-100)/2-10, (self.pg_height-20)/2, 20, 20)];
    }
    return _iconImageView;
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-100)/2+20, (self.pg_height-20)/2, 100, 20)];
        _nameLabel.font = Theme.fontExtraLargeBold;
        _nameLabel.textColor = Theme.colorText;
    }
    return _nameLabel;
}

- (UIView *)dotView
{
    if (!_dotView) {
        _dotView = [[UIView alloc] initWithFrame:CGRectMake(self.nameLabel.frame.origin.x+self.nameLabel.frame.size.width+3, self.nameLabel.frame.origin.y-2, 8, 8)];
        _dotView.clipsToBounds = YES;
        _dotView.layer.cornerRadius = 4.f;
        _dotView.backgroundColor = [UIColor colorWithRed:239.f/256.f green:103.f/256.f blue:51.f/256.f alpha:1.f];
    }
    return _dotView;
}

@end
