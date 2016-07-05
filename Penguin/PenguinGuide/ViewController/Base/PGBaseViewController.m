//
//  PGBaseViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"

@interface PGBaseViewController ()

@property (nonatomic, strong, readwrite) PGAPIClient *apiClient;

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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

#pragma mark - <Setters && Getters>

- (PGAPIClient *)apiClient
{
    if (_apiClient) {
        _apiClient = [PGAPIClient client];
    }
    
    return _apiClient;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
