//
//  PGCommentReportViewController.m
//  Penguin
//
//  Created by Kobe Dai on 29/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCommentReportViewController.h"

@interface PGCommentReportViewController () <UITextViewDelegate>

@property (nonatomic, strong) NSString *commentId;

@property (nonatomic, strong) UITextView *reportTextView;
@property (nonatomic, strong) UIButton *reportButton;

@end

@implementation PGCommentReportViewController

- (id)initWithCommentId:(NSString *)commentId
{
    if (self = [super init]) {
        self.commentId = commentId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    // NOTE: fix UITextView top white space: http://stackoverflow.com/questions/18931934/blank-space-at-top-of-uitextview-in-ios-10
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self setNavigationTitle:@"举报"];
    
    [self.view addSubview:self.reportTextView];
    [self.view addSubview:self.reportButton];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.reportTextView resignFirstResponder];
}

#pragma mark - <UITextViewDelegate>

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    // NOTE: UITextView hit return key: http://stackoverflow.com/questions/703754/how-to-dismiss-keyboard-for-uitextview-with-return-key
    if([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    
    return YES;
}

#pragma mark - <Button Events>

- (void)reportButtonClicked
{
    if (self.reportTextView.text.length > 0) {
        PGWeakSelf(self);
        
        PGParams *params = [PGParams new];
        params[@"type"] = @(1);
        params[@"content"] = self.reportTextView.text;
        params[@"entity_id"] = self.commentId;
        
        [self.apiClient pg_makePostRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Report;
            config.keyPath = nil;
            config.params = params;
        } completion:^(id response) {
            [weakself showToast:@"已提交举报"];
            [weakself.navigationController popViewControllerAnimated:YES];
        } failure:^(NSError *error) {
            [weakself showErrorMessage:error];
        }];
    } else {
        [self showToast:@"请输入举报内容"];
    }
}

#pragma mark - <Init Lazy>

- (UITextView *)reportTextView
{
    if (!_reportTextView) {
        _reportTextView = [[UITextView alloc] initWithFrame:CGRectMake(28, 64+25, UISCREEN_WIDTH-28*2, 200)];
        _reportTextView.font = Theme.fontMediumBold;
        _reportTextView.clipsToBounds = YES;
        _reportTextView.layer.borderWidth = 1/[UIScreen mainScreen].scale;
        _reportTextView.layer.borderColor = Theme.colorText.CGColor;
        _reportTextView.layer.cornerRadius = 4.f;
        _reportTextView.returnKeyType = UIReturnKeyDone;
        _reportTextView.delegate = self;
    }
    return _reportTextView;
}

- (UIButton *)reportButton
{
    if (!_reportButton) {
        _reportButton = [[UIButton alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-134)/2, self.reportTextView.pg_bottom+30, 134, 32)];
        _reportButton.backgroundColor = Theme.colorText;
        _reportButton.clipsToBounds = YES;
        _reportButton.layer.cornerRadius = 16.f;
        [_reportButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_reportButton setTitle:@"提 交" forState:UIControlStateNormal];
        [_reportButton.titleLabel setFont:Theme.fontMediumBold];
        [_reportButton addTarget:self action:@selector(reportButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _reportButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
