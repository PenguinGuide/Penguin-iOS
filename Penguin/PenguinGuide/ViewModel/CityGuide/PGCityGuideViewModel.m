//
//  PGCityGuideViewModel.m
//  Penguin
//
//  Created by Jing Dai on 28/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCityGuideViewModel.h"

@interface PGCityGuideViewModel ()

@property (nonatomic, strong, readwrite) NSArray *citiesArray;

@end

@implementation PGCityGuideViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_City_Guide_Cities;
        config.keyPath = nil;
        config.model = [PGCityGuideCity new];
    } completion:^(id response) {
        weakself.citiesArray = response;
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

@end
