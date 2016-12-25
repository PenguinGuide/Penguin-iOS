//
//  PGSearchRecommendsViewModel.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchRecommendsViewModel.h"

@interface PGSearchRecommendsViewModel ()

@property (nonatomic, strong, readwrite) NSArray *recommends;

@end

@implementation PGSearchRecommendsViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Search_Recommends;
        config.keyPath = nil;
    } completion:^(id response) {
        weakself.recommends = response;
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

@end
