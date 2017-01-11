//
//  PGMeCell.m
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMeCell.h"

@interface PGMeCell ()

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
    [self.contentView addSubview:self.nameLabel];
    [self.contentView addSubview:self.dotView];
}

- (void)setCellWithName:(NSString *)name highlight:(BOOL)highlight
{
    self.nameLabel.text = name;
    if (highlight) {
        self.dotView.hidden = NO;
    } else {
        self.dotView.hidden = YES;
    }
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, 70);
}

- (UILabel *)nameLabel
{
    if (!_nameLabel) {
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-70)/2, (self.pg_height-16)/2, 70, 16)];
        _nameLabel.textAlignment = NSTextAlignmentCenter;
        _nameLabel.font = Theme.fontMediumBold;
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
