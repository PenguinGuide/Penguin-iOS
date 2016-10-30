//
//  PGCollectionViewModel.m
//  Penguin
//
//  Created by Jing Dai on 30/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCollectionViewModel.h"

@interface PGCollectionViewModel ()

@property (nonatomic, strong, readwrite) NSArray *collections;

@end

@implementation PGCollectionViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Channel_Collections;
        config.keyPath = nil;
        config.model = [PGCollection new];
    } completion:^(id response) {
        weakself.collections = response;
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

@end
