//
//  PGHistoryViewModel.m
//  Penguin
//
//  Created by Jing Dai on 31/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGHistoryViewModel.h"

@interface PGHistoryViewModel ()

@property (nonatomic, strong, readwrite) NSArray *histories;

@end

@implementation PGHistoryViewModel

- (void)requestData
{
    if (PGGlobal.userId && PGGlobal.userId.length > 0) {
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
        
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_History;
            config.keyPath = @"items";
            config.pattern = @{@"userId":PGGlobal.userId};
            config.model = [PGHistory new];
            config.response = weakself.response;
        } paginationCompletion:^(PGRKResponse *response) {
            weakself.response = response;
            weakself.histories = response.dataArray;
            weakself.endFlag = response.pagination.endFlag;
            
            weakself.isPreloadingNextPage = NO;
        } failure:^(NSError *error) {
            weakself.error = error;
            
            weakself.isPreloadingNextPage = NO;
        }];
    }
}

@end
