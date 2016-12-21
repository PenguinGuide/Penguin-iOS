//
//  PGSearchRecommendsHistoryCell.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchRecommendsHistoryCell.h"

@interface PGSearchRecommendsHistoryCell ()

@property (nonatomic, strong) UILabel *historyLabel;

@end

@implementation PGSearchRecommendsHistoryCell

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
    [self.contentView addSubview:self.historyLabel];
}

- (void)setCellWithStr:(NSString *)str
{
    self.historyLabel.text = str;
}

+ (CGSize)cellSize
{
    return CGSizeMake(UISCREEN_WIDTH, 50);
}

- (UILabel *)historyLabel {
	if(_historyLabel == nil) {
		_historyLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, UISCREEN_WIDTH-40, self.pg_height)];
        _historyLabel.font = Theme.fontExtraLargeBold;
        _historyLabel.textColor = [UIColor colorWithHexString:@"6c6c6c"];
	}
	return _historyLabel;
}

@end
