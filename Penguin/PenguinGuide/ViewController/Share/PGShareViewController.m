//
//  PGShareViewController.m
//  Penguin
//
//  Created by Jing Dai on 18/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGShareViewController.h"
#import "PGShareButton.h"
#import "SDWebImageManager.h"

@interface PGShareViewController ()

@property (nonatomic, strong) UIView *topDimView;
@property (nonatomic, strong) UIView *shareView;
@property (nonatomic, strong) UIImageView *articleShareImageView;

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UILabel *titleLabel;

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
    
    self.articleShareImageView.image = self.attribute.shareViewImage;
    self.dayLabel.text = self.attribute.day;
    self.monthLabel.text = self.attribute.month;
    self.yearLabel.text = self.attribute.year;
    self.titleLabel.text = self.attribute.title;
    
    __block CGFloat height = (UISCREEN_WIDTH-28*2)*190/264+94;
    
    PGWeakSelf(self);
    [UIView animateWithDuration:0.4f
                          delay:0.f
         usingSpringWithDamping:0.75f
          initialSpringVelocity:0.8f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         weakself.shareView.frame = CGRectMake(weakself.shareView.pg_x, (UISCREEN_HEIGHT-height)/2, weakself.shareView.pg_width, weakself.shareView.pg_height);
                     } completion:^(BOOL finished) {
                         
                     }];
}

- (void)reloadView
{
    [self hideNetworkLostPlaceholder];
}

- (void)momentsButtonClicked
{
    if (self.attribute.url && self.attribute.url.length > 0) {
        PGWeakSelf(self);
        [self showLoading];
        [PGShareManager shareItem:^(PGShareItem *shareItem) {
            shareItem.text = weakself.attribute.text;
            shareItem.title = weakself.attribute.title;
            shareItem.image = weakself.attribute.image;
            shareItem.thumbnailImage = weakself.attribute.thumbnailImage;
            shareItem.url = weakself.attribute.url;
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
    if (self.attribute.url && self.attribute.url.length > 0) {
        PGWeakSelf(self);
        [self showLoading];
        [PGShareManager shareItem:^(PGShareItem *shareItem) {
            shareItem.text = weakself.attribute.text;
            shareItem.title = weakself.attribute.title;
            shareItem.image = weakself.attribute.image;
            shareItem.thumbnailImage = weakself.attribute.thumbnailImage;
            shareItem.url = weakself.attribute.url;
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
    if (self.attribute.url && self.attribute.url.length > 0) {
        PGWeakSelf(self);
        [self showLoading];
        NSString *cropQuery = @"?imageView2/0/w/400/h/400";
        NSString *imageUrl = [weakself.attribute.image stringByAppendingString:cropQuery];
        [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:imageUrl]
                                                    options:SDWebImageHighPriority
                                                   progress:nil
                                                  completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                                                      [PGShareManager shareItem:^(PGShareItem *shareItem) {
                                                          shareItem.text = weakself.attribute.text;
                                                          shareItem.title = weakself.attribute.title;
                                                          shareItem.image = weakself.attribute.image;
                                                          shareItem.weiboImage = image;
                                                          shareItem.thumbnailImage = weakself.attribute.thumbnailImage;
                                                          shareItem.url = weakself.attribute.url;
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
                                                  }];
    } else {
        [self showToast:@"分享失败"];
    }
}

- (void)linkButtonClicked
{
    if (self.attribute.url && self.attribute.url.length > 0) {
        UIPasteboard *pb = [UIPasteboard generalPasteboard];
        [pb setString:self.attribute.url];
        [self showToast:@"复制成功"];
    } else {
        [self showToast:@"复制失败"];
    }
}

- (void)closeButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <Lazy Init>

- (UIView *)topDimView
{
    if (!_topDimView) {
        _topDimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
        _topDimView.backgroundColor = [UIColor clearColor];
    }
    return _topDimView;
}

- (UIView *)shareView
{
    if (!_shareView) {
        CGFloat width = UISCREEN_WIDTH-28*2;
        CGFloat height = (UISCREEN_WIDTH-28*2)*190/264+94;
        
        _shareView = [[UIView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2, UISCREEN_HEIGHT, width, height)];
        _shareView.backgroundColor = [UIColor whiteColor];
        _shareView.clipsToBounds = YES;
        _shareView.layer.cornerRadius = 5.f;
        
        float delta = (UISCREEN_WIDTH-28*2-25*2-60*4)/3;
        
        [_shareView addSubview:self.articleShareImageView];
        
        PGShareButton *momentsButton = [[PGShareButton alloc] initWithFrame:CGRectMake(25, height-94+20, 60, 60)];
        [momentsButton setImage:@"pg_share_moments" title:@"朋友圈"];
        [momentsButton addTarget:self action:@selector(momentsButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:momentsButton];
        
        PGShareButton *wechatButton = [[PGShareButton alloc] initWithFrame:CGRectMake(momentsButton.pg_right+delta, height-94+20, 60, 60)];
        [wechatButton setImage:@"pg_share_wechat" title:@"微信"];
        [wechatButton addTarget:self action:@selector(wechatButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:wechatButton];
        
        PGShareButton *weiboButton = [[PGShareButton alloc] initWithFrame:CGRectMake(wechatButton.pg_right+delta, height-94+20, 60, 60)];
        [weiboButton setImage:@"pg_share_weibo" title:@"微博"];
        [weiboButton addTarget:self action:@selector(weiboButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:weiboButton];
        
        PGShareButton *linkButton = [[PGShareButton alloc] initWithFrame:CGRectMake(weiboButton.pg_right+delta, height-94+20, 60, 60)];
        [linkButton setImage:@"pg_share_link" title:@"复制链接"];
        [linkButton addTarget:self action:@selector(linkButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_shareView addSubview:linkButton];
    }
    return _shareView;
}

- (UIImageView *)articleShareImageView
{
    if (!_articleShareImageView) {
        CGFloat width = UISCREEN_WIDTH-28*2;
        CGFloat height = (UISCREEN_WIDTH-28*2)*190/264+94;
        
        _articleShareImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, width, height-94)];
        _articleShareImageView.backgroundColor = Theme.colorBackground;
        _articleShareImageView.clipsToBounds = YES;
        _articleShareImageView.contentMode = UIViewContentModeScaleAspectFill;
        _articleShareImageView.userInteractionEnabled = YES;
        
        UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, _articleShareImageView.pg_width, _articleShareImageView.pg_height)];
        dimView.backgroundColor = [UIColor blackColorWithAlpha:0.3];
        [_articleShareImageView addSubview:dimView];
        
        [_articleShareImageView addSubview:self.dayLabel];
        
        UIView *verticleLine = [[UIView alloc] initWithFrame:CGRectMake(66, 34, 2, 26)];
        verticleLine.backgroundColor = [UIColor whiteColor];
        [_articleShareImageView addSubview:verticleLine];
        
        [_articleShareImageView addSubview:self.monthLabel];
        [_articleShareImageView addSubview:self.yearLabel];
        [_articleShareImageView addSubview:self.titleLabel];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(width-60, 10, 50, 50)];
        [closeButton setImage:[UIImage imageNamed:@"pg_login_close"] forState:UIControlStateNormal];
        [closeButton addTarget:self action:@selector(closeButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_articleShareImageView addSubview:closeButton];
    }
    return _articleShareImageView;
}

- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, 32, 40, 30)];
        _dayLabel.font = [UIFont systemFontOfSize:28.f weight:UIFontWeightMedium];
        _dayLabel.textColor = [UIColor whiteColor];
    }
    return _dayLabel;
}

- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, 32, 37, 15)];
        _monthLabel.font = Theme.fontSmallBold;
        _monthLabel.textColor = [UIColor whiteColor];
    }
    return _monthLabel;
}

- (UILabel *)yearLabel
{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(76, self.monthLabel.pg_bottom, 37, 15)];
        _yearLabel.font = Theme.fontSmallBold;
        _yearLabel.textColor = [UIColor whiteColor];
    }
    return _yearLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        CGFloat width = UISCREEN_WIDTH-28*2;
        CGFloat height = (UISCREEN_WIDTH-28*2)*190/264;
        if (DEVICE_IS_LESS_OR_EQUAL_TO_IPHONE_5) {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, height-20-84, width-52-26, 84)];
        } else {
            _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(26, height-30-84, width-52-26, 84)];
        }
        _titleLabel.font = [UIFont systemFontOfSize:20.f weight:UIFontWeightMedium];
        _titleLabel.textColor = [UIColor whiteColor];
        _titleLabel.numberOfLines = 3;
    }
    return _titleLabel;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
