//
//  PGBaseViewModel.m
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"

@interface PGBaseViewModel ()

@property (nonatomic, strong, readwrite) PGAPIClient *apiClient;

@end

@implementation PGBaseViewModel

- (id)initWithAPIClient:(PGAPIClient *)apiClient
{
    if (self = [super init]) {
        self.apiClient = apiClient;
        self.page = 1;
        self.cursor = nil;
        self.endFlag = NO;
    }
    
    return self;
}

- (void)requestData
{
    
}

- (void)loadNextPage
{
    
}

@end
