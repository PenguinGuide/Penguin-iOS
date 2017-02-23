//
//  PGVideoPlayerViewController.m
//  Penguin
//
//  Created by Jing Dai on 24/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

typedef NS_ENUM(NSInteger, GestureDirection) {
    GestureDirectionUp,
    GestureDirectionDown,
    GestureDirectionLeft,
    GestureDirectionRight
};

#import "PGVideoPlayerViewController.h"
#import <AVFoundation/AVFoundation.h>
#import <MediaPlayer/MediaPlayer.h>

#import "PGVideoPlayerSlider.h"
#import "PGVideoVolumeSlider.h"

@interface PGVideoPlayerViewController () <PGVideoPlayerSliderDelegate>

@property (nonatomic, strong) NSString *videoURL;

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

@property (nonatomic, assign) GestureDirection currentGestureDirection;
@property (nonatomic, assign) BOOL gestureIsProcessing;
@property (nonatomic, assign) float currentPlayerSliderValue;
@property (nonatomic, assign) float currentVolumeSliderValue;
@property (nonatomic, assign) float currentSystemVolumeSliderValue;

@end

@implementation PGVideoPlayerViewController

- (id)initWithVideoURL:(NSString *)url
{
    if (self = [super init]) {
        self.videoURL = @"https://cdn-video-1.penguinguide.cn/generic720";
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(systemVolumeChanged:) name:@"AVSystemController_SystemVolumeDidChangeNotification" object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(playerItemPlaybackStalled:) name:AVPlayerItemPlaybackStalledNotification object:nil];
    
    // http://blog.csdn.net/jeffasd/article/details/50718284
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.systemVolumeView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // NOTE: video player landscape orientation
    // http://www.cnblogs.com/ladyotao/p/5674194.html
    // http://blog.csdn.net/wws6773075/article/details/51144225
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationPortrait]  forKey:@"orientation"];
    [[UIDevice currentDevice] setValue:[NSNumber numberWithInteger:UIDeviceOrientationLandscapeLeft] forKey:@"orientation"];
    
    [self.view.layer addSublayer:self.playerLayer];
    
    [self.view addSubview:self.videoDimView];
    [self.videoDimView addSubview:self.backButton];
    //[self.videoDimView addSubview:self.shareButton];
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

- (void)dealloc
{
    [self.playerItem removeObserver:self forKeyPath:@"status" context:nil];
    [self.playerItem removeObserver:self forKeyPath:@"loadedTimeRanges" context:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self];
    self.player = nil;
    self.playerItem = nil;
    self.playerLayer = nil;
}

- (void)reloadView
{
    [self hideNetworkLostPlaceholder];
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations
{
    return UIInterfaceOrientationMaskLandscape;
}

- (BOOL)shouldHideNavigationBar
{
    return YES;
}

- (BOOL)shouldAutorotate
{
    return YES;
}

#pragma mark - <Player KVO>

- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSKeyValueChangeKey,id> *)change context:(void *)context
{
    if ([keyPath isEqualToString:@"status"]) {
        [self handlePlayerItemStatusChanged:change];
    } else if ([keyPath isEqualToString:@"loadedTimeRanges"]) {
        [self handlePlayerItemLoadedTimeRangesChanged];
    }
    
    NSLog(@"changed: %@", change);
}

- (void)handlePlayerItemStatusChanged:(NSDictionary<NSKeyValueChangeKey,id> *)change
{
    AVPlayerStatus status = [[change objectForKey:@"new"] intValue];
    if (status == AVPlayerStatusReadyToPlay) {
        [self pausePlaying];
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
                                                                         
                                                                         if (!weakself.gestureIsProcessing) {
                                                                             weakself.playerSlider.value = currentTime/currentDuration;
                                                                         }
                                                                         
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

- (void)handlePlayerItemLoadedTimeRangesChanged
{
    NSArray *loadedTimeRanges = self.playerItem.loadedTimeRanges;
    CMTimeRange timeRange = [loadedTimeRanges.firstObject CMTimeRangeValue];
    float startTime = CMTimeGetSeconds(timeRange.start);
    float duration = CMTimeGetSeconds(timeRange.duration);
    NSTimeInterval totalBuffer = startTime + duration;
    
    NSLog(@"total buffer: %@", @(totalBuffer));
    
    if (self.player.rate == 0) {
        if (CMTimeGetSeconds(self.playerItem.currentTime) < totalBuffer-2) {
            [self continuePlaying];
        }
    }
}

- (void)continuePlaying
{
    [self dismissLoading];
    [self.player play];
    [self.playButton setTag:1];
    [self.playButton setImage:[UIImage imageNamed:@"pg_video_pause"] forState:UIControlStateNormal];
}

- (void)pausePlaying
{
    //[self showLoading];
    [self.player pause];
    [self.playButton setTag:0];
    [self.playButton setImage:[UIImage imageNamed:@"pg_video_play"] forState:UIControlStateNormal];
}

#pragma mark - <PGVideoPlayerSliderDelegate>

- (void)playerSliderValueChanged
{
    [self.player pause];
    
    PGWeakSelf(self);
    [self.playerItem seekToTime:CMTimeMakeWithSeconds(self.playerSlider.value*CMTimeGetSeconds(self.playerItem.duration), self.playerItem.duration.timescale)
              completionHandler:^(BOOL finished) {
                  [weakself continuePlaying];
                  //[weakself showLoading];
              }];
}

#pragma mark - <Gesture>

- (void)playerPanGestureRecognized:(UIPanGestureRecognizer *)gesture
{
    if (self.player.status == AVPlayerStatusReadyToPlay) {
        UIGestureRecognizerState state = gesture.state;
        if (state == UIGestureRecognizerStateBegan) {
            CGPoint velocity = [gesture velocityInView:self.view];
            self.gestureIsProcessing = YES;
            self.currentPlayerSliderValue = self.playerSlider.value;
            self.currentVolumeSliderValue = self.volumeSlider.value;
            self.currentSystemVolumeSliderValue = self.systemVolumeSlider.value;
            if (fabs(velocity.x) >= fabs(velocity.y)) {
                if (velocity.x >= 0) {
                    self.currentGestureDirection = GestureDirectionRight;
                } else {
                    self.currentGestureDirection = GestureDirectionLeft;
                }
            } else {
                if (velocity.y >= 0) {
                    self.currentGestureDirection = GestureDirectionDown;
                } else {
                    self.currentGestureDirection = GestureDirectionUp;
                }
            }
        } else if (state == UIGestureRecognizerStateChanged) {
            CGPoint translation = [gesture translationInView:self.view];
            if (self.currentGestureDirection == GestureDirectionUp || self.currentGestureDirection == GestureDirectionDown) {
                if (translation.y <= 0) {
                    // increase volume
                    float scale = fabs(translation.y)/self.volumeSlider.pg_height;
                    if (self.currentGestureDirection == GestureDirectionDown) {
                        self.currentVolumeSliderValue = self.volumeSlider.value;
                        self.currentSystemVolumeSliderValue = self.systemVolumeSlider.value;
                    }
                    [self.volumeSlider setValue:MIN(1.f, self.currentVolumeSliderValue+scale)];
                    if (self.systemVolumeSlider.value < 1.f) {
                        self.systemVolumeSlider.value = self.currentSystemVolumeSliderValue+scale;
                    }
                    self.currentGestureDirection = GestureDirectionUp;
                } else {
                    // decrease volume
                    float scale = fabs(translation.y)/self.volumeSlider.pg_height;
                    if (self.currentGestureDirection == GestureDirectionUp) {
                        self.currentVolumeSliderValue = self.volumeSlider.value;
                        self.currentSystemVolumeSliderValue = self.systemVolumeSlider.value;
                    }
                    [self.volumeSlider setValue:MAX(0.f, self.currentVolumeSliderValue-scale)];
                    if (self.systemVolumeSlider.value > 0.f) {
                        self.systemVolumeSlider.value = self.currentSystemVolumeSliderValue-scale;
                    }
                    self.currentGestureDirection = GestureDirectionDown;
                }
            } else if (self.currentGestureDirection == GestureDirectionRight || self.currentGestureDirection == GestureDirectionLeft) {
                if (translation.x >= 0) {
                    // forward
                    self.forwardButton.hidden = NO;
                    self.backwardButton.hidden = YES;
                    float scale = fabs(translation.x)/self.playerSlider.pg_width;
                    if (self.currentGestureDirection == GestureDirectionLeft) {
                        self.currentPlayerSliderValue = self.playerSlider.value;
                    }
                    self.playerSlider.value = MIN(1.f, self.currentPlayerSliderValue+scale);
                    self.currentGestureDirection = GestureDirectionRight;
                } else {
                    // backward
                    self.backwardButton.hidden = NO;
                    self.forwardButton.hidden = YES;
                    float scale = fabs(translation.x)/self.playerSlider.pg_width;
                    if (self.currentGestureDirection == GestureDirectionRight) {
                        self.currentPlayerSliderValue = self.playerSlider.value;
                    }
                    self.playerSlider.value = MAX(0.f, self.currentPlayerSliderValue-scale);
                    self.currentGestureDirection = GestureDirectionLeft;
                }
            }
        } else {
            self.gestureIsProcessing = NO;
            self.currentPlayerSliderValue = self.playerSlider.value;
            self.currentPlayerSliderValue = self.volumeSlider.value;
            self.currentSystemVolumeSliderValue = self.systemVolumeSlider.value;
            self.backwardButton.hidden = YES;
            self.forwardButton.hidden = YES;
            if (self.currentGestureDirection == GestureDirectionLeft || self.currentGestureDirection == GestureDirectionRight) {
                [self playerSliderValueChanged];
            }
        }
    }
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

- (void)playerItemPlaybackStalled:(NSNotification *)notification
{
    [self pausePlaying];
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
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(4.f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        weakself.videoDimView.hidden = YES;
    });
}

#pragma mark - <Setters && Getters>

- (AVPlayer *)player
{
    if (!_player) {
        _player = [AVPlayer playerWithPlayerItem:self.playerItem];
        
        // NOTE: fucking 10.0 issue!!! player not playing http://www.jianshu.com/p/17df68e8f4ca
        if (SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
            self.player.automaticallyWaitsToMinimizeStalling = NO;
        }
    }
    return _player;
}

- (AVPlayerItem *)playerItem
{
    if (!_playerItem) {
        _playerItem = [AVPlayerItem playerItemWithURL:[NSURL URLWithString:self.videoURL]];
        [_playerItem addObserver:self forKeyPath:@"status" options:NSKeyValueObservingOptionNew context:nil];
        [_playerItem addObserver:self forKeyPath:@"loadedTimeRanges" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _playerItem;
}

- (AVPlayerLayer *)playerLayer
{
    if (!_playerLayer) {
        _playerLayer = [AVPlayerLayer playerLayerWithPlayer:self.player];
        _playerLayer.frame = CGRectMake(0, 0, self.view.pg_height, self.view.pg_width);
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
        _forwardButton = [[UIButton alloc] initWithFrame:CGRectMake(self.playButton.pg_right+90, UISCREEN_WIDTH/2-25, 50, 50)];
        _forwardButton.hidden = YES;
        [_forwardButton setImage:[UIImage imageNamed:@"pg_video_forward"] forState:UIControlStateNormal];
    }
    return _forwardButton;
}

- (UIButton *)backwardButton
{
    if (!_backwardButton) {
        _backwardButton = [[UIButton alloc] initWithFrame:CGRectMake(self.playButton.pg_left-90-50, UISCREEN_WIDTH/2-25, 50, 50)];
        _backwardButton.hidden = YES;
        [_backwardButton setImage:[UIImage imageNamed:@"pg_video_backward"] forState:UIControlStateNormal];
    }
    return _backwardButton;
}

- (PGVideoVolumeSlider *)volumeSlider
{
    if (!_volumeSlider) {
        _volumeSlider = [[PGVideoVolumeSlider alloc] initWithFrame:CGRectMake(30, UISCREEN_WIDTH/2-133.f/2, 30, 133)];
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
