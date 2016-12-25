//
//  PGSearchResultsHeaderView.m
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchResultsHeaderView.h"
#import "PGSearchTextField.h"

@interface PGSearchResultsHeaderView () <UITextFieldDelegate>

@property (nonatomic, strong) PGSearchTextField *searchTextField;
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
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.searchTextField];
    [self addSubview:self.backButton];
    [self addSubview:self.cancelButton];
}

- (void)setHeaderViewWithKeyword:(NSString *)keyword
{
    self.searchTextField.text = keyword;
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

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length == 0) {
        return NO;
    }
    
    if (self.delegate && [self.delegate respondsToSelector:@selector(searchButtonClicked:)]) {
        [textField resignFirstResponder];
        [self.delegate searchButtonClicked:textField.text];
    }
    return YES;
}

- (UITextField *)searchTextField {
    if(_searchTextField == nil) {
        _searchTextField = [[PGSearchTextField alloc] initWithFrame:CGRectMake(35, 25, UISCREEN_WIDTH-30-50, 30)];
        _searchTextField.placeholder = @"请输入关键词";
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.delegate = self;
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

- (UIButton *)backButton {
	if(_backButton == nil) {
		_backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 25, 40, 30)];
        [_backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
	}
	return _backButton;
}

@end
