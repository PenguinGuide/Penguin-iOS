//
//  PGMeViewModel.m
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMeViewModel.h"

@interface PGMeViewModel ()

@property (nonatomic, strong, readwrite) PGMe *me;

@end

@implementation PGMeViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Me;
        config.model = [PGMe new];
        config.keyPath = @"data";
        config.isMockAPI = YES;
        config.mockFileName = @"pg_me.json";
    } completion:^(id response) {
        weakself.me = [response firstObject];
    } failure:^(NSError *error) {
        
    }];
}

@end
