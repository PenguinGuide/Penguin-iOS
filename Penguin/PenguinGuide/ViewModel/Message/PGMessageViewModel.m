//
//  PGMessageViewModel.m
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMessageViewModel.h"

@interface PGMessageViewModel ()

@property (nonatomic, strong, readwrite) NSArray *messages;

@end

@implementation PGMessageViewModel

- (void)requestData
{
    
}

- (void)requestSystemMessages
{
    PGParams *params = [PGParams new];
    params[@"type"] = @(1);
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Message;
        config.params = params;
        config.keyPath = nil;
        config.model = [PGMessage new];
    } completion:^(id response) {
        weakself.messages = response;
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

- (void)requestReplyMessages
{
    PGParams *params = [PGParams new];
    params[@"type"] = @(2);
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Message;
        config.params = params;
        config.keyPath = nil;
        config.model = [PGMessage new];
    } completion:^(id response) {
        weakself.messages = response;
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

@end
