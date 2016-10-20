//
//  PGSegmentView.m
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSegmentView.h"

@interface PGSegmentView ()

@property (nonatomic, strong) NSArray *segmentsArray;
@property (nonatomic, strong) NSArray *buttonsArray;
@property (nonatomic, strong) UIView *segmentLine;
@property (nonatomic, assign) NSInteger currentSelectedIndex;

@end

@implementation PGSegmentView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = Theme.colorBackground;
        
        CGFloat height = 1 / [UIScreen mainScreen].scale;
        UIView *bottomLine = [[UIView alloc] initWithFrame:CGRectMake(0, frame.size.height-height, UISCREEN_WIDTH, height)];
        bottomLine.backgroundColor = [UIColor colorWithHexString:@"E1E1E1"];
        [self addSubview:bottomLine];
    }
    return self;
}

- (void)setViewWithSegments:(NSArray *)segments
{
    if (segments.count > 0) {
        for (UIButton *button in self.buttonsArray) {
            [button removeFromSuperview];
        }
        [self.segmentLine removeFromSuperview];
        
        self.segmentsArray = segments;
        CGFloat buttonWidth = self.pg_width/self.segmentsArray.count;
        
        NSMutableArray *buttonsArray = [NSMutableArray new];
        for (int i = 0; i < self.segmentsArray.count; i++) {
            NSString *segmentStr = self.segmentsArray[i];
            
            UIButton *segmentButton = [[UIButton alloc] initWithFrame:CGRectMake(i*buttonWidth, 0, buttonWidth, self.pg_height)];
            [segmentButton setTitle:segmentStr forState:UIControlStateNormal];
            [segmentButton setTitleColor:Theme.colorText forState:UIControlStateSelected];
            [segmentButton setTitleColor:Theme.colorLightText forState:UIControlStateNormal];
            [segmentButton.titleLabel setFont:Theme.fontMediumBold];
            [segmentButton addTarget:self action:@selector(segmentButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            segmentButton.tag = i;
            [buttonsArray addObject:segmentButton];
            [self addSubview:segmentButton];
            
            if (i == 0) {
                segmentButton.selected = YES;
                self.segmentLine.frame = CGRectMake(0, self.pg_height-2, self.pg_width/self.segmentsArray.count, 2);
                [self addSubview:self.segmentLine];
            }
        }
        
        self.buttonsArray = [NSArray arrayWithArray:buttonsArray];
    }
}

- (void)segmentButtonClicked:(id)sender
{
    __block UIButton *currentSelectedButton = (UIButton *)sender;
    
    if (currentSelectedButton) {
        UIButton *lastSelectedButton = self.buttonsArray[self.currentSelectedIndex];
        lastSelectedButton.selected = NO;
        
        self.currentSelectedIndex = currentSelectedButton.tag;
        currentSelectedButton.selected = YES;
        
        PGWeakSelf(self)
        [UIView animateWithDuration:0.2f animations:^{
            weakself.segmentLine.frame = CGRectMake(currentSelectedButton.pg_x, weakself.segmentLine.pg_y, weakself.segmentLine.pg_width, weakself.segmentLine.pg_height);
        }];
        
        if (self.delegate && [self.delegate respondsToSelector:@selector(segmentDidClicked:)]) {
            [self.delegate segmentDidClicked:self.currentSelectedIndex];
        }
    }
}

- (UIView *)segmentLine {
	if(_segmentLine == nil) {
		_segmentLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.pg_height-2, self.pg_width/self.segmentsArray.count, 2)];
        _segmentLine.backgroundColor = Theme.colorExtraHighlight;
	}
	return _segmentLine;
}

@end
