//
//  PGShareViewController.m
//  Penguin
//
//  Created by Jing Dai on 18/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGShareViewController.h"
#import "PGShareButton.h"

@interface PGShareViewController ()

@property (nonatomic, strong) UIView *topDimView;
@property (nonatomic, strong) UIView *shareView;

@property (nonatomic, strong) NSString *shareLink;
@property (nonatomic, strong) NSString *shareText;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareImage;
@property (nonatomic, strong) NSString *shareThumbnail;

@end

@implementation PGShareViewController

- (id)initWithShareLink:(NSString *)shareLink text:(NSString *)text title:(NSString *)title image:(NSString *)image thumbnail:(NSString *)thumbnail
{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.8f];
        
        self.shareLink = shareLink;
        self.shareText = text;
        self.shareTitle = title;
        self.shareImage = image;
        self.shareThumbnail = thumbnail;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.topDimView];
    [self.view addSubview:self.shareView];
    
    PGWeakSelf(self);
    [self.topDimView setTapAction:^{
        [weakself dismissViewControllerAnimated:YES completion:nil];
    }];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    PGWeakSelf(self);
    [UIView animateWithDuration:0.2f
                          delay:0.f
         usingSpringWithDamping:1.f
          initialSpringVelocity:0.5f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         weakself.shareView.frame = CGRectMake(0, UISCREEN_HEIGHT-140, UISCREEN_WIDTH, 140);
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)momentsButtonClicked
{
    if (self.shareLink && self.shareLink.length > 0) {
        PGWeakSelf(self);
        [self showLoading];
        [PGShareManager shareItem:^(PGShareItem *shareItem) {
            shareItem.text = weakself.shareText;
            shareItem.title = weakself.shareTitle;
            shareItem.image = weakself.shareImage;
            shareItem.thumbnailImage = weakself.shareThumbnail;
            shareItem.url = weakself.shareLink;
        } toPlatform:SSDKPlatformSubTypeWechatTimeline
                       completion:^(SSDKResponseState state) {
                           if (state == SSDKResponseStateSuccess) {
                               [self showToast:@"分享成功"];
                           } else if (state == SSDKResponseStateCancel) {
                               [self showToast:@"分享取消"];
                           } else if (state == SSDKResponseStateFail) {
                               [self showToast:@"分享失败"];
                           }
                           [weakself dismissLoading];
                       }];
    } else {
        [self showToast:@"分享失败"];
    }
}

- (void)wechatButtonClicked
{
    if (self.shareLink && self.shareLink.length > 0) {
        PGWeakSelf(self);
        [self showLoading];
        [PGShareManager shareItem:^(PGShareItem *shareItem) {
            shareItem.text = weakself.shareText;
            shareItem.title = weakself.shareTitle;
            shareItem.image = weakself.shareImage;
            shareItem.thumbnailImage = weakself.shareThumbnail;
            shareItem.url = weakself.shareLink;
        } toPlatform:SSDKPlatformSubTypeWechatSession
                       completion:^(SSDKResponseState state) {
                           if (state == SSDKResponseStateSuccess) {
                               [self showToast:@"分享成功"];
                           } else if (state == SSDKResponseStateCancel) {
                               [self showToast:@"分享取消"];
                           } else if (state == SSDKResponseStateFail) {
                               [self showToast:@"分享失败"];
                           }
                           [weakself dismissLoading];
                       }];
    } else {
        [self showToast:@"分享失败"];
    }
}

- (void)weiboButtonClicked
{
    if (self.shareLink && self.shareLink.length > 0) {
        PGWeakSelf(self);
        [self showLoading];
        [PGShareManager shareItem:^(PGShareItem *shareItem) {
            shareItem.text = weakself.shareText;
            shareItem.title = weakself.shareTitle;
            shareItem.image = weakself.shareImage;
            shareItem.thumbnailImage = weakself.shareThumbnail;
            shareItem.url = weakself.shareLink;
        } toPlatform:SSDKPlatformTypeSinaWeibo
                       completion:^(SSDKResponseState state) {
                           if (state == SSDKResponseStateSuccess) {
                               [self showToast:@"分享成功"];
                           } else if (state == SSDKResponseStateCancel) {
                               [self showToast:@"分享取消"];
                           } else if (state == SSDKResponseStateFail) {
                               [self showToast:@"分享失败"];
                           }
                           [weakself dismissLoading];
                       }];
    } else {
        [self showToast:@"分享失败"];
    }
}

- (void)linkButtonClicked
{
    if (self.shareLink && self.shareLink.length > 0) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:self.shareLink];
        [self showToast:@"复制成功"];
    } else {
        [self showToast:@"复制失败"];
    }
}

- (void)cancelButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <Lazy Init>

- (UIView *)topDimView
{
    if (!_topDimView) {
        _topDimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT-140)];
        _topDimView.backgroundColor = [UIColor clearColor];
    }
    return _topDimView;
}

- (UIView *)shareView
{
    if (!_shareView) {
        _shareView = [[UIView alloc] initWithFrame:CGRectMake(0, UISCREEN_HEIGHT, UISCREEN_WIDTH, 140)];
        _shareView.backgroundColor = [UIColor whiteColorWithAlpha:0.8f];
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(25, 140-44-1/[UIScreen mainScreen].scale, UISCREEN_WIDTH-50, 1/[UIScreen mainScreen].scale)];
        horizontalLine.backgroundColor = Theme.colorText;
        [_shareView addSubview:horizontalLine];
        
        float delta = (UISCREEN_WIDTH-30*2-60*4)/3;
        
        PGShareButton *momentsButton = [[PGShareButton alloc] initWithFrame:CGRectMake(30, 20, 60, 60)];
        [momentsButton setImage:@"pg_share_moments" title:@"朋友圈"];
        [momentsButton addTarget:self action:@selector(momentsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:momentsButton];
        
        PGShareButton *wechatButton = [[PGShareButton alloc] initWithFrame:CGRectMake(momentsButton.pg_right+delta, 20, 60, 60)];
        [wechatButton setImage:@"pg_share_wechat" title:@"微信"];
        [wechatButton addTarget:self action:@selector(wechatButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:wechatButton];
        
        PGShareButton *weiboButton = [[PGShareButton alloc] initWithFrame:CGRectMake(wechatButton.pg_right+delta, 20, 60, 60)];
        [weiboButton setImage:@"pg_share_weibo" title:@"微博"];
        [weiboButton addTarget:self action:@selector(weiboButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:weiboButton];
        
        PGShareButton *linkButton = [[PGShareButton alloc] initWithFrame:CGRectMake(weiboButton.pg_right+delta, 20, 60, 60)];
        [linkButton setImage:@"pg_share_link" title:@"复制链接"];
        [linkButton addTarget:self action:@selector(linkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:linkButton];
        
        UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 140-44, UISCREEN_WIDTH, 44)];
        [cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:Theme.fontMedium];
        [cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        
        [_shareView addSubview:cancelButton];
    }
    return _shareView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
