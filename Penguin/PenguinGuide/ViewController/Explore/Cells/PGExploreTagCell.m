//
//  PGExploreTagsCell.m
//  Penguin
//
//  Created by Kobe Dai on 17/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGExploreTagCell.h"
#import "PGTag.h"

@interface PGExploreTagCell ()

@property (nonatomic, strong) UIImageView *tagImageView;
@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation PGExploreTagCell

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
    [self.contentView addSubview:self.tagImageView];
    [self.contentView addSubview:self.tagLabel];
}

+ (CGSize)cellSize
{
    return CGSizeMake(50, 50+7+14);
}

- (void)setCellWithModel:(PGRKModel *)model
{
    if ([model isKindOfClass:[PGTag class]]) {
        PGTag *tag = (PGTag *)model;
        
        [self.tagImageView setWithImageURL:tag.image placeholder:nil completion:nil];
        [self.tagLabel setText:tag.name];
    }
}

- (UIImageView *)tagImageView
{
    if (!_tagImageView) {
        _tagImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, self.pg_width)];
        _tagImageView.clipsToBounds = YES;
        _tagImageView.backgroundColor = [UIColor whiteColor];
        
        CAShapeLayer *shapeLayer = [CAShapeLayer layer];
        shapeLayer.frame = CGRectMake(0, 0, self.pg_width, self.pg_width);
        shapeLayer.lineWidth = 1.f;
        shapeLayer.strokeColor = Theme.colorBackground.CGColor;
        shapeLayer.fillColor = [UIColor clearColor].CGColor;
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.pg_width, self.pg_width) cornerRadius:4.f];
        shapeLayer.path = bezierPath.CGPath;
        
        [_tagImageView.layer insertSublayer:shapeLayer atIndex:0];
    }
    return _tagImageView;
}

- (UILabel *)tagLabel
{
    if (!_tagLabel) {
        _tagLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.tagImageView.pg_bottom+7, self.pg_width, 14)];
        _tagLabel.font = Theme.fontSmallBold;
        _tagLabel.textColor = Theme.colorText;
        _tagLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _tagLabel;
}

@end
