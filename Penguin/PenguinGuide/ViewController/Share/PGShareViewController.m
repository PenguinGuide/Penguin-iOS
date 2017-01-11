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
@property (nonatomic, strong) UIImageView *imageView;
@property (nonatomic, strong) UILabel *titleLabel;

@property (nonatomic, strong) NSString *shareLink;
@property (nonatomic, strong) NSString *shareText;
@property (nonatomic, strong) NSString *shareTitle;
@property (nonatomic, strong) NSString *shareImage;
@property (nonatomic, strong) NSString *shareThumbnail;

@property (nonatomic, strong) PGShareAttribute *attribute;

@end

@implementation PGShareViewController

- (id)initWithShareAttribute:(PGShareAttribute *)attribute
{
    if (self = [super init]) {
        self.modalPresentationStyle = UIModalPresentationOverCurrentContext;
        self.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        self.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.6f];
        
        self.attribute = attribute;
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
    
    self.imageView.image = self.attribute.shareViewImage;
    
//    PGWeakSelf(self);
//    [UIView animateWithDuration:0.2f
//                          delay:0.f
//         usingSpringWithDamping:1.f
//          initialSpringVelocity:0.5f
//                        options:UIViewAnimationOptionCurveEaseInOut
//                     animations:^{
//                         weakself.shareView.frame = CGRectMake(0, UISCREEN_HEIGHT-140, UISCREEN_WIDTH, 140);
//                     } completion:^(BOOL finished) {
//                         
//                     }];
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
        //264/190
        CGFloat width = UISCREEN_WIDTH-28*2;
        CGFloat height = (UISCREEN_WIDTH-28*2)*190/264+94;
        
        _shareView = [[UIView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2, (UISCREEN_HEIGHT-height)/2, width, height)];
        _shareView.backgroundColor = [UIColor whiteColor];
        _shareView.clipsToBounds = YES;
        _shareView.layer.cornerRadius = 5.f;
        
        float delta = (UISCREEN_WIDTH-28*2-25*2-60*4)/3;
        
        self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height-94)];
        self.imageView.backgroundColor = Theme.colorBackground;
        self.imageView.clipsToBounds = YES;
        self.imageView.contentMode = UIViewContentModeScaleAspectFill;
        [_shareView addSubview:self.imageView];
        
        UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.imageView.pg_width, self.imageView.pg_height)];
        dimView.backgroundColor = [UIColor blackColorWithAlpha:0.3];
        [self.imageView addSubview:dimView];
        
        PGShareButton *momentsButton = [[PGShareButton alloc] initWithFrame:CGRectMake(25, self.imageView.pg_bottom+20, 60, 60)];
        [momentsButton setImage:@"pg_share_moments" title:@"朋友圈"];
        [momentsButton addTarget:self action:@selector(momentsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:momentsButton];
        
        PGShareButton *wechatButton = [[PGShareButton alloc] initWithFrame:CGRectMake(momentsButton.pg_right+delta, self.imageView.pg_bottom+20, 60, 60)];
        [wechatButton setImage:@"pg_share_wechat" title:@"微信"];
        [wechatButton addTarget:self action:@selector(wechatButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:wechatButton];
        
        PGShareButton *weiboButton = [[PGShareButton alloc] initWithFrame:CGRectMake(wechatButton.pg_right+delta, self.imageView.pg_bottom+20, 60, 60)];
        [weiboButton setImage:@"pg_share_weibo" title:@"微博"];
        [weiboButton addTarget:self action:@selector(weiboButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:weiboButton];
        
        PGShareButton *linkButton = [[PGShareButton alloc] initWithFrame:CGRectMake(weiboButton.pg_right+delta, self.imageView.pg_bottom+20, 60, 60)];
        [linkButton setImage:@"pg_share_link" title:@"复制链接"];
        [linkButton addTarget:self action:@selector(linkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:linkButton];
    }
    return _shareView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
