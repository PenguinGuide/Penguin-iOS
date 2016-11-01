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
        PGWeakSelf(self);
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_History;
            config.keyPath = @"items";
            config.pattern = @{@"userId":PGGlobal.userId};
            config.model = [PGHistory new];
        } completion:^(id response) {
            weakself.histories = response;
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

@end
