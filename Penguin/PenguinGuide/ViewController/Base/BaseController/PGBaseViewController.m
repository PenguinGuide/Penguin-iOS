//
//  PGBaseViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGBaseViewController+TransitionAnimation.h"

@interface PGBaseViewController () <UINavigationControllerDelegate>

@property (nonatomic, strong, readwrite) PGAPIClient *apiClient;
@property (nonatomic, strong, readwrite) FBKVOController *KVOController;

@end

@implementation PGBaseViewController

- (id)init
{
    if (self = [super init]) {
        self.apiClient = [PGAPIClient client];
    }
    
    return self;
}

- (void)dealloc
{
    [self.apiClient cancelAllRequests];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor whiteColor];
    
    UIImage *backButtonImage = [[UIImage imageNamed:@"pg_navigation_back_button"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithImage:backButtonImage
                                                                             style:UIBarButtonItemStyleDone
                                                                            target:self
                                                                            action:@selector(backButtonClicked)];
    // fix left sliding not working
    self.navigationController.interactivePopGestureRecognizer.delegate = (id)self;
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    // http://benscheirman.com/2011/08/when-viewwillappear-isnt-called/
    self.navigationController.delegate = self;
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    self.navigationController.delegate = nil;
}

#pragma mark - <Back Button>

- (void)backButtonClicked
{
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - <KVO Methods>

- (void)observe:(id)object keyPath:(NSString *)keyPath block:(void (^)(id changedObject))block
{
    [self.KVOController observe:object
                        keyPath:keyPath
                        options:NSKeyValueObservingOptionInitial|NSKeyValueObservingOptionNew
                          block:^(id  _Nullable observer, id  _Nonnull object, NSDictionary<NSString *,id> * _Nonnull change) {
                              if (block) {
                                  block(change[NSKeyValueChangeNewKey]);
                              }
                          }];
}

- (void)unobserve
{
    [self.KVOController unobserveAll];
}

#pragma mark - <Setters && Getters>

- (PGAPIClient *)apiClient
{
    if (_apiClient) {
        _apiClient = [PGAPIClient client];
    }
    
    return _apiClient;
}

- (FBKVOController *)KVOController
{
    if (!_KVOController) {
        _KVOController = [FBKVOController controllerWithObserver:self];
    }
    return _KVOController;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
