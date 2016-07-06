//
//  PGBaseViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"
#import "FBKVOController.h"

@interface PGBaseViewController ()

@property (nonatomic, strong, readwrite) PGAPIClient *apiClient;
@property (nonatomic, strong, readwrite) FBKVOController *KVOController;

@end

@implementation PGBaseViewController

- (id)init
{
    if (self = [super init]) {
        
    }
    
    return self;
}

- (void)dealloc
{
    [self.apiClient cancelAllRequests];
    [self.KVOController unobserveAll];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
