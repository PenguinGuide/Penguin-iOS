//
//  PGVideoPlayerViewController.m
//  Penguin
//
//  Created by Jing Dai on 24/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "PGVideoPlayerSlider.h"
#import "PGVideoVolumeSlider.h"

@interface PGVideoPlayerViewController () <PGVideoPlayerSliderDelegate>

@property (nonatomic, strong) AVPlayer *player;
@property (nonatomic, strong) AVPlayerItem *playerItem;
@property (nonatomic, strong) AVPlayerLayer *playerLayer;

@property (nonatomic, strong) id playTimeObserver;
@property (nonatomic, strong) id playerEndObserver;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *shareButton;
@property (nonatomic, strong) UIButton *playButton;
@property (nonatomic, strong) UIButton *forwardButton;
@property (nonatomic, strong) UIButton *backwardButton;

@property (nonatomic, strong) UILabel *elapsedLabel;
@property (nonatomic, strong) UILabel *durationLabel;
@property (nonatomic, strong) UIView *videoDimView;

@property (nonatomic, strong) PGVideoPlayerSlider *playerSlider;
@property (nonatomic, strong) PGVideoVolumeSlider *volumeSlider;

@property (nonatomic, strong) UISlider *systemVolumeSlider;
@property (nonatomic, strong) MPVolumeView *systemVolumeView;

@property (nonatomic, strong) UIPanGestureRecognizer *playerPanGesture;
@property (nonatomic, strong) UITapGestureRecognizer *playerTapGesture;

@property (nonatomic, assign) int currentVolumeTranslationScale;
@property (nonatomic, assign) float currentPlayerTranslationScale;

@end

@implementation PGVideoPlayerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    
    // http://blog.csdn.net/jeffasd/article/details/50718284
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.systemVolumeView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // ISSUE: video player landscape orientation
    // http://www.cnblogs.com/ladyotao/p/5674194.html
    // http://blog.csdn.net/wws6773075/article/details/51144225
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait]  forKey:@"orientation"];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    
    [self.view.layer addSublayer:self.playerLayer];
    
    [self.view addSubview:self.videoDimView];
    [self.videoDimView addSubview:self.backButton];
    [self.videoDimView addSubview:self.shareButton];
    [self.videoDimView addSubview:self.playButton];
    [self.videoDimView addSubview:self.forwardButton];
    [self.videoDimView addSubview:self.backwardButton];
    [self.videoDimView addSubview:self.volumeSlider];
    [self.videoDimView addSubview:self.elapsedLabel];
    [self.videoDimView addSubview:self.playerSlider];
    [self.videoDimView addSubview:self.durationLabel];
    
    self.playerPanGesture = [[UIPanGestureRecognizer alloc] initWithTarget:self action:@selector(playerPanGestureRecognized:)];
    [self.view addGestureRecognizer:self.playerPanGesture];
    self.playerTapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(playerTapGestureRecognized:)];
    [self.view addGestureRecognizer:self.playerTapGesture];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = YES;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = NO;
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    AppDelegate *appDelegate = (AppDelegate *)[UIApplication sharedApplication].delegate;
    appDelegate.allowRotation = NO;
    
    self.navigationController.interactivePopGestureRecognizer.enabled = YES;
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
        if (status == AVPlayerStatusReadyToPlay) {
            // time label
            NSTimeInterval duration = CMTimeGetSeconds(self.playerItem.duration);
            int mins = duration/60;
            int secs = duration-mins*60;
            if (mins < 10) {
                if (secs < 10) {
                    self.durationLabel.text = [NSString stringWithFormat:@"0%d:0%d", mins, secs];
                } else {
                    self.durationLabel.text = [NSString stringWithFormat:@"0%d:%d", mins, secs];
                }
            } else {
                if (secs < 10) {
                    self.durationLabel.text = [NSString stringWithFormat:@"%d:0%d", mins, secs];
                } else {
                    self.durationLabel.text = [NSString stringWithFormat:@"%d:%d", mins, secs];
                }
            }
            self.elapsedLabel.text = @"00:00";
            
            // NOTE: get system volume http://www.jianshu.com/p/5016b72c52bd
            for (UIView *view in self.systemVolumeView.subviews) {
                if ([view isKindOfClass:[UISlider class]]) {
                    self.systemVolumeSlider = (UISlider *)view;
                    [self.volumeSlider setValue:self.systemVolumeSlider.value];
                }
            }
            
            // NOTE: time observer http://blog.csdn.net/reylen/article/details/46982809
            PGWeakSelf(self);
            self.playTimeObserver = [self.player addPeriodicTimeObserverForInterval:CMTimeMakeWithSeconds(1.0, NSEC_PER_SEC)
                                                                              queue:dispatch_get_main_queue()
                                                                         usingBlock:^(CMTime time) {
                                                                             NSTimeInterval currentTime = CMTimeGetSeconds(time);
                                                                             NSTimeInterval currentDuration = CMTimeGetSeconds(weakself.playerItem.duration);
                                                                             
                                                                             weakself.playerSlider.value = currentTime/currentDuration;
                                                                             
                                                                             int currentMins = currentTime/60;
                                                                             int currentSecs = currentTime-currentMins*60;
                                                                             
                                                                             if (currentMins < 10) {
                                                                                 if (currentSecs < 10) {
                                                                                     weakself.elapsedLabel.text = [NSString stringWithFormat:@"0%d:0%d", currentMins, currentSecs];
                                                                                 } else {
                                                                                     weakself.elapsedLabel.text = [NSString stringWithFormat:@"0%d:%d", currentMins, currentSecs];
                                                                                 }
                                                                             } else {
                                                                                 if (currentSecs < 10) {
                                                                                     weakself.elapsedLabel.text = [NSString stringWithFormat:@"%d:0%d", currentMins, currentSecs];
                                                                                 } else {
                                                                                     weakself.elapsedLabel.text = [NSString stringWithFormat:@"%d:%d", currentMins, currentSecs];
                                                                                 }
                                                                             }
                                                                         }];
            self.playerEndObserver = [[NSNotificationCenter defaultCenter] addObserverForName:AVPlayerItemDidPlayToEndTimeNotification
                                                                                       object:weakself.playerItem
                                                                                        queue:[NSOperationQueue mainQueue]
                                                                                   usingBlock:^(NSNotification * _Nonnull note) {
                                                                                       [weakself.playerItem seekToTime:kCMTimeZero];
                                                                                       [weakself.playButton setTag:0];
                                                                                       [weakself.playButton setImage:[UIImage imageNamed:@"pg_video_play"] forState:UIControlStateNormal];
                                                                                   }];
            
        } else {
            self.durationLabel.text = @"00:00";
            self.elapsedLabel.text = @"00:00";
        }
    }
}

#pragma mark - <PGVideoPlayerSliderDelegate>

- (void)playerSliderValueChanged
{
    [self.player pause];
    
    PGWeakSelf(self);
    [self.playerItem seekToTime:CMTimeMakeWithSeconds(self.playerSlider.value*CMTimeGetSeconds(self.playerItem.duration), self.playerItem.duration.timescale) completionHandler:^(BOOL finished) {
        [weakself.player play];
        [weakself.playButton setTag:0];
        [weakself.playButton setImage:[UIImage imageNamed:@"pg_video_play"] forState:UIControlStateNormal];
    }];
}

#pragma mark - <Gesture>

- (void)playerPanGestureRecognized:(UIPanGestureRecognizer *)gesutre
{
    CGPoint translation = [gesutre translationInView:self.view];
    
    if (fabs(translation.x) <= fabs(translation.y)) {
        // vertical direction
        if (translation.y <= 0) {
            // increase volume
            int scale = (int)fabs(translation.y)/10;
            if (scale != self.currentVolumeTranslationScale) {
                self.currentVolumeTranslationScale = scale;
                if (self.systemVolumeSlider.value < 1.f) {
                    self.systemVolumeSlider.value = self.systemVolumeSlider.value+0.1;
                    
                    [self.volumeSlider setValue:self.systemVolumeSlider.value];
                }
            }
        } else {
            // decrease volume
            int scale = (int)fabs(translation.y)/10;
            if (scale != self.currentVolumeTranslationScale) {
                self.currentVolumeTranslationScale = scale;
                if (self.systemVolumeSlider.value > 0.f) {
                    self.systemVolumeSlider.value = self.systemVolumeSlider.value-0.1;
                    
                    [self.volumeSlider setValue:self.systemVolumeSlider.value];
                }
            }
        }
    } else {
        // horizontal direction
        if ([gesutre velocityInView:self.view].x >= 0) {
            // forward
            self.forwardButton.hidden = NO;
            self.backwardButton.hidden = YES;
            float scale = fabs(translation.x)/self.playerSlider.width;
            self.playerSlider.value = self.playerSlider.value+(scale-self.currentPlayerTranslationScale);
            self.currentPlayerTranslationScale = scale;
            
            [self playerSliderValueChanged];
        } else {
            // backward
            self.backwardButton.hidden = NO;
            self.forwardButton.hidden = YES;
            float scale = fabs(translation.x)/self.playerSlider.width;
            self.playerSlider.value = self.playerSlider.value-(scale-self.currentPlayerTranslationScale);
            self.currentPlayerTranslationScale = scale;
            
            [self playerSliderValueChanged];
        }
    }
    
    if (gesutre.state == UIGestureRecognizerStateEnded || gesutre.state == UIGestureRecognizerStateFailed || gesutre.state == UIGestureRecognizerStateCancelled) {
        self.forwardButton.hidden = YES;
        self.backwardButton.hidden = YES;
        self.currentPlayerTranslationScale = 0.f;
    } else if (gesutre.state == UIGestureRecognizerStateBegan) {
        self.videoDimView.hidden = NO;
    }
    
    NSLog(@"velocity: %@", NSStringFromCGPoint([gesutre velocityInView:self.view]));
}

- (void)playerTapGestureRecognized:(UITapGestureRecognizer *)gesture
{
    if (self.videoDimView.hidden) {
        self.videoDimView.hidden = NO;
    } else {
        self.videoDimView.hidden = YES;
    }
}

#pragma mark - <Notification>

- (void)systemVolumeChanged:(NSNotification *)notification
{
    [self.volumeSlider setValue:[[notification.userInfo objectForKey:@"AVSystemController_AudioVolumeNotificationParameter"] floatValue]];
}

#pragma mark - <Events>

- (void)playButtonClicked:(id)sender
{
    if (self.playButton.tag == 0) {
        [self.player play];
        self.playButton.tag = 1;
        [self.playButton setImage:[UIImage imageNamed:@"pg_video_pause"] forState:UIControlStateNormal];
    } else {
        [self.player pause];
        self.playButton.tag = 0;
        [self.playButton setImage:[UIImage imageNamed:@"pg_video_play"] forState:UIControlStateNormal];
    }
    
    PGWeakSelf(self);
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.videoDimView.hidden = YES;
    });
}

#pragma mark - <Setters && Getters>

- (AVPlayer *)player
{
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
    }
    return _player;
}

- (AVPlayerItem *)playerItem
{
    if (!_playerItem) {
//        NSURL *url = [NSURL URLWithString:@"http://222.73.3.97/vhot2.qqvideo.tc.qq.com/g0328tr4ibr.mp4?vkey=D1A814BF316E2BCC33A722E71BE64AD720B5916AABCD0AAFE1B13436DC3458B3AB1B0A4CF4110DE6A999A6D22BF33256B6C0FE24DB81CECD8C44810B4C4331503DFF51A86C561589FECE1E0C4C6A1EE9CE5B9838ABB2110B&br=60&platform=2&fmt=auto&level=0&sdtfrom=v3010&locid=a1ea72b8-dc52-4fb0-8c8b-c675fb1fc509&size=6713441&ocid=3390775212"];
        NSURL *url = [NSURL fileURLWithPath:[[NSBundle mainBundle] pathForResource:@"video" ofType:@"mp4"]];
        _playerItem = [AVPlayerItem playerItemWithURL:url];
        
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _playerItem;
}

- (AVPlayerLayer *)playerLayer
{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = CGRectMake(0, 0, self.view.height, self.view.width);
        _playerLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
        ;
    }
    return _playerLayer;
}

- (UIButton *)backButton
{
    if (!_backButton) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 70, 70)];
        [_backButton setImage:[UIImage imageNamed:@"pg_video_back_button"] forState:UIControlStateNormal];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (UIButton *)shareButton
{
    if (!_shareButton) {
        _shareButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_HEIGHT-70, 0, 70, 70)];
        [_shareButton setImage:[UIImage imageNamed:@"pg_video_share"] forState:UIControlStateNormal];
    }
    return _shareButton;
}

- (UIButton *)playButton
{
    if (!_playButton) {
        _playButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_HEIGHT/2-25, UISCREEN_WIDTH/2-25, 50, 50)];
        [_playButton setImage:[UIImage imageNamed:@"pg_video_play"] forState:UIControlStateNormal];
        [_playButton addTarget:self action:@selector(playButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _playButton;
}

- (UIButton *)forwardButton
{
    if (!_forwardButton) {
        _forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(self.playButton.right+90, UISCREEN_WIDTH/2-25, 50, 50)];
        _forwardButton.hidden = YES;
        [_forwardButton setImage:[UIImage imageNamed:@"pg_video_forward"] forState:UIControlStateNormal];
    }
    return _forwardButton;
}

- (UIButton *)backwardButton
{
    if (!_backwardButton) {
        _backwardButton = [[UIButton alloc] initWithFrame:CGRectMake(self.playButton.left-90-50, UISCREEN_WIDTH/2-25, 50, 50)];
        _backwardButton.hidden = YES;
        [_backwardButton setImage:[UIImage imageNamed:@"pg_video_backward"] forState:UIControlStateNormal];
    }
    return _backwardButton;
}

- (PGVideoVolumeSlider *)volumeSlider
{
    if (!_volumeSlider) {
        _volumeSlider = [[PGVideoVolumeSlider alloc] initWithFrame:CGRectMake(15, UISCREEN_WIDTH/2-133.f/2, 30, 133)];
    }
    return _volumeSlider;
}

- (MPVolumeView *)systemVolumeView
{
    if (!_systemVolumeView) {
        _systemVolumeView = [[MPVolumeView alloc] initWithFrame:CGRectZero];
        // NOTE: set hidden to YES will not hide the volume view http://www.tuicool.com/articles/NRzAziU
        _systemVolumeView.hidden = NO;
    }
    return _systemVolumeView;
}

- (UILabel *)elapsedLabel
{
    if (!_elapsedLabel) {
        _elapsedLabel = [[UILabel alloc] initWithFrame:CGRectMake(20, UISCREEN_WIDTH-17-16, 50, 16)];
        _elapsedLabel.font = Theme.fontMediumBold;
        _elapsedLabel.textColor = [UIColor whiteColor];
        _elapsedLabel.textAlignment = NSTextAlignmentLeft;
    }
    return _elapsedLabel;
}

- (UILabel *)durationLabel
{
    if (!_durationLabel) {
        _durationLabel = [[UILabel alloc] initWithFrame:CGRectMake(UISCREEN_HEIGHT-20-50, UISCREEN_WIDTH-17-16, 50, 16)];
        _durationLabel.font = Theme.fontMediumBold;
        _durationLabel.textColor = [UIColor whiteColor];
        _durationLabel.textAlignment = NSTextAlignmentRight;
    }
    return _durationLabel;
}

- (UIView *)videoDimView
{
    if (!_videoDimView) {
        _videoDimView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_HEIGHT, UISCREEN_WIDTH)];
        _videoDimView.backgroundColor = [UIColor blackColorWithAlpha:0.3f];
    }
    return _videoDimView;
}

- (PGVideoPlayerSlider *)playerSlider
{
    if (!_playerSlider) {
        _playerSlider = [[PGVideoPlayerSlider alloc] initWithFrame:CGRectMake(70, UISCREEN_WIDTH-50, UISCREEN_HEIGHT-140, 50)];
        _playerSlider.delegate = self;
    }
    return _playerSlider;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
