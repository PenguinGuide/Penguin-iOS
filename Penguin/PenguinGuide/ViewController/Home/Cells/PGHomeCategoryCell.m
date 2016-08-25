//
//  PGHomeCategoryCell.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGHomeCategoryCell.h"

@implementation PGHomeCategoryCell

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initialize];
    }
    
    return self;
}

- (void)initialize
{
    [self.contentView addSubview:self.categoryButton];
    [self.categoryButton addSubview:self.categoryLabel];
}

- (UIButton *)categoryButton {
    if(_categoryButton == nil) {
        _categoryButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, self.width, self.height)];
        [_categoryButton setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 20, 0)];
    }
    return _categoryButton;
}

- (UILabel *)categoryLabel {
    if(_categoryLabel == nil) {
        _categoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.height-28, self.width, 16)];
        _categoryLabel.font = Theme.fontExtraSmallBold;
        _categoryLabel.textColor = Theme.colorText;
        _categoryLabel.textAlignment = NSTextAlignmentCenter;
    }
    return _categoryLabel;
}

@end
