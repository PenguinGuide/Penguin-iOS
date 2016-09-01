//
//  PGSearchResultsHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchResultsHeaderView.h"
#import "PGSearchTextField.h"
#import "PGSegmentView.h"

@interface PGSearchResultsHeaderView () <PGSegmentViewDelegate>

@property (nonatomic, strong) PGSearchTextField *searchTextField;
@property (nonatomic, strong) PGSegmentView *segmentView;
@property (nonatomic, strong) NSArray *segments;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *backButton;

@end

@implementation PGSearchResultsHeaderView

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
    self.backgroundColor = Theme.colorBackground;
    
    [self addSubview:self.searchTextField];
    [self addSubview:self.backButton];
    [self addSubview:self.cancelButton];
    [self addSubview:self.segmentView];
}

- (void)setHeaderViewWithKeyword:(NSString *)keyword segments:(NSArray *)segments
{
    self.searchTextField.text = keyword;
    self.segments = segments;
    
    [self.segmentView setViewWithSegments:self.segments];
}

- (void)cancelButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(cancelButtonClicked)]) {
        [self.delegate cancelButtonClicked];
    }
}

- (void)backButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(backButtonClicked)]) {
        [self.delegate backButtonClicked];
    }
}

#pragma mark - <PGSegmentViewDelegate>

- (void)segmentDidClicked:(NSInteger)index
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(segmentDidClicked:)]) {
        [self.delegate segmentDidClicked:index];
    }
}

- (UITextField *)searchTextField {
    if(_searchTextField == nil) {
        _searchTextField = [[PGSearchTextField alloc] initWithFrame:CGRectMake(35, 25, UISCREEN_WIDTH-30-50, 30)];
        _searchTextField.placeholder = @"请输入关键词";
        _searchTextField.returnKeyType = UIReturnKeySearch;
    }
    return _searchTextField;
}

- (UIButton *)cancelButton {
    if(_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-50, 25, 50, 30)];
        [_cancelButton.titleLabel setFont:Theme.fontSmallBold];
        [_cancelButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (PGSegmentView *)segmentView {
	if(_segmentView == nil) {
		_segmentView = [[PGSegmentView alloc] initWithFrame:CGRectMake(0, self.searchTextField.bottom, UISCREEN_WIDTH, self.height-self.searchTextField.bottom)];
        _segmentView.delegate = self;
	}
	return _segmentView;
}

- (UIButton *)backButton {
	if(_backButton == nil) {
		_backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, 40, 30)];
        [_backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	}
	return _backButton;
}

@end
