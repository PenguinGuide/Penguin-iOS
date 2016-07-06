//
//  PGLoginViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginViewController.h"
#import "PGTourView.h"
#import "PGLoginView.h"

@interface PGLoginViewController ()

@property (nonatomic, strong) UIImageView *bgImageView;
@property (nonatomic, strong) UIView *currentView;

@property (nonatomic, strong) PGTourView *tourView;

@end

@implementation PGLoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self.view addSubview:self.bgImageView];
    [self.view addSubview:self.tourView];
    
    self.currentView = self.tourView;
}

- (BOOL)prefersStatusBarHidden
{
    return YES;
}

#pragma mark - <Setters && Getters>

- (UIImageView *)bgImageView
{
    if (!_bgImageView) {
        _bgImageView = [[UIImageView alloc] initWithFrame:self.view.bounds];
        UIImage *blurredImage = [[UIImage imageNamed:@"pg_login_bg"] applyBlurEffectWithRadius:5 tintColor:[UIColor whiteColorWithAlpha:0.1f] saturationDeltaFactor:1 maskImage:nil];
        _bgImageView.image = blurredImage;
    }
    
    return _bgImageView;
}

- (PGTourView *)tourView
{
    if (!_tourView) {
        float width = 260.f * (UISCREEN_WIDTH/320);
        float height = 420.f * (UISCREEN_HEIGHT/568);
        _tourView = [[PGTourView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2, (UISCREEN_HEIGHT-height)/2, width, height)];
        
        [_tourView.loginButton addTarget:self action:@selector(tourLoginButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_tourView.registerButton addTarget:self action:@selector(tourRegisterButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    
    return _tourView;
}

- (void)tourLoginButtonClicked
{
    float width = 260.f * (UISCREEN_WIDTH/320);
    float height = 420.f * (UISCREEN_HEIGHT/568);
    PGLoginView *loginView = [[PGLoginView alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-width)/2+UISCREEN_WIDTH, (UISCREEN_HEIGHT-height)/2, width, height)];
    [self.view addSubview:loginView];
    
    CGRect tourViewFrame = self.tourView.frame;
    
    [UIView animateWithDuration:0.5f
                          delay:0.f
         usingSpringWithDamping:0.6f
          initialSpringVelocity:0.7f
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.tourView.frame = CGRectMake(-tourViewFrame.size.width, tourViewFrame.origin.y, tourViewFrame.size.width, tourViewFrame.size.height);
                         loginView.frame = CGRectMake((UISCREEN_WIDTH-width)/2, (UISCREEN_HEIGHT-height)/2, width, height);
                     } completion:^(BOOL finished) {
                         [self.tourView removeFromSuperview];
                     }];
}

- (void)tourRegisterButtonClicked
{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
