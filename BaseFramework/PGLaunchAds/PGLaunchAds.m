//
//  PGLaunchAds.m
//  Penguin
//
//  Created by Jing Dai on 8/10/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLaunchAds.h"

@interface PGLaunchAds ()

@property (nonatomic, strong) UIWindow *window;
@property (nonatomic, strong) UIImageView *adsView;
@property (nonatomic, assign) NSInteger countdownSec;

@end

@implementation PGLaunchAds

+ (PGLaunchAds *)sharedInstance
{
    static PGLaunchAds *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PGLaunchAds alloc] init];
    });
    
    return sharedInstance;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationDidFinishLaunchingNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self checkAds];
                                                          });
                                                      }];
        [[NSNotificationCenter defaultCenter] addObserverForName:UIApplicationWillEnterForegroundNotification
                                                          object:nil
                                                           queue:nil
                                                      usingBlock:^(NSNotification * _Nonnull note) {
                                                          dispatch_async(dispatch_get_main_queue(), ^{
                                                              [self checkAds];
                                                          });
                                                      }];
    }
    return self;
}

- (void)checkAds
{
    [self showAds];
}

- (void)showAds
{
    self.countdownSec = 3;
    
    self.window = [[UIWindow alloc] initWithFrame:[UIScreen mainScreen].bounds];
    self.window.windowLevel = UIWindowLevelStatusBar + 1;
    self.window.hidden = NO;    // default is NO, set to YES will show the window
    
    [self.window addSubview:self.adsView];
    
    [self countdown];
}

- (void)hideAds
{
    [self.adsView removeFromSuperview];
    self.window.alpha = 1.f;
    self.window.hidden = YES;
    self.window = nil;
}

- (void)countdown
{
    if (self.countdownSec <= 0) {
        [self hideAds];
    } else {
        self.countdownSec--;
        __weak typeof(self) weakSelf = self;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [weakSelf countdown];
        });
    }
}

- (UIView *)adsView {
	if(_adsView == nil) {
		_adsView = [[UIImageView alloc] initWithFrame:[UIScreen mainScreen].bounds];
        _adsView.image = [UIImage imageNamed:@"ad"];
	}
	return _adsView;
}

@end
