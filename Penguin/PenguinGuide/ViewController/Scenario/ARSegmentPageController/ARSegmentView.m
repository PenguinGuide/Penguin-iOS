//
//  ARSegmentView.m
//  ARSegmentPager
//
//  Created by August on 15/3/28.
//  Copyright (c) 2015年 August. All rights reserved.
//

#import "ARSegmentView.h"

@implementation ARSegmentView {
  UIView *_bottomLine;
}

#pragma mark - init methods

- (instancetype)init {
  self = [super init];
  if (self) {
    [self _baseConfigs];
  }
  return self;
}

#pragma mark - private methods

- (void)_baseConfigs {
    
    _segmentControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 50)];
    _segmentControl.backgroundColor = [UIColor whiteColor];
    
    _allButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH/2, 50)];
    [_allButton setTitle:@"全 部" forState:UIControlStateNormal];
    [_allButton setTitleColor:Theme.colorLightText forState:UIControlStateNormal];
    [_allButton setTitleColor:Theme.colorText forState:UIControlStateSelected];
    _allButton.tag = 0;
    
    _goodsButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH/2, 0, UISCREEN_WIDTH/2, 50)];
    [_goodsButton setTitle:@"商 品" forState:UIControlStateNormal];
    [_goodsButton setTitleColor:Theme.colorLightText forState:UIControlStateNormal];
    [_goodsButton setTitleColor:Theme.colorText forState:UIControlStateSelected];
    _goodsButton.tag = 1;
    
    _allButton.selected = YES;
    
    [_segmentControl addSubview:_allButton];
    [_segmentControl addSubview:_goodsButton];

    [self addSubview:self.segmentControl];
}

@end
