//
//  PGAllScenariosViewModel.m
//  Penguin
//
//  Created by Jing Dai on 30/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGAllScenariosViewModel.h"
#import "PGScenarioBanner.h"

@interface PGAllScenariosViewModel ()

@property (nonatomic, strong, readwrite) NSArray *scenariosArray;

@end

@implementation PGAllScenariosViewModel

- (void)requestScenarios:(NSString *)scenarioType
{
    if (scenarioType && scenarioType.length > 0) {
        if (self.isPreloadingNextPage || self.endFlag) {
            return;
        }
        
        self.isPreloadingNextPage = YES;
        
        if (!self.response) {
            self.response = [[PGRKResponse alloc] init];
            self.response.pagination.needPerformingBatchUpdate = NO;
            self.response.pagination.paginationKey = @"next";
            self.response.pagination.paginatedSection = NO;
        }
        
        PGWeakSelf(self);
        
        PGParams *params = [PGParams new];
        params[ParamsPerPage] = @10;
        params[@"type"] = scenarioType;
        
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Scenarios;
            config.keyPath = @"items";
            config.params = params;
            config.model = [PGScenarioBanner new];
            config.response = weakself.response;
        } paginationCompletion:^(PGRKResponse *response) {
            weakself.response = response;
            weakself.scenariosArray = response.dataArray;
            weakself.endFlag = response.pagination.endFlag;
            
            self.isPreloadingNextPage = NO;
        } failure:^(NSError *error) {
            weakself.error = error;
            
            self.isPreloadingNextPage = NO;
        }];
    }
}

@end
