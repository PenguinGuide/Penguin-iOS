//
//  PGMessageViewModel.m
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMessageViewModel.h"

@interface PGMessageViewModel ()

@property (nonatomic, strong, readwrite) NSDictionary *countsDict;
@property (nonatomic, strong, readwrite) NSArray *messages;

@end

@implementation PGMessageViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Message_Counts;
        config.keyPath = nil;
    } completion:^(id response) {
        weakself.countsDict = [response firstObject];
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

- (void)requestSystemMessages
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    
    self.isPreloadingNextPage = YES;
    
    if (!self.response) {
        self.response = [PGRKResponse responseWithNextPagination];
    }
    
    PGParams *params = [PGParams new];
    params[@"type"] = @(1);
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Message;
        config.params = params;
        config.keyPath = @"items";
        config.model = [PGMessage new];
        config.response = weakself.response;
    } paginationCompletion:^(PGRKResponse *response) {
        weakself.response = response;
        weakself.messages = response.dataArray;
        weakself.endFlag = response.pagination.endFlag;
        
        weakself.isPreloadingNextPage = NO;
    } failure:^(NSError *error) {
        weakself.error = error;
        
        weakself.isPreloadingNextPage = NO;
    }];
}

- (void)requestReplyMessages
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    
    self.isPreloadingNextPage = YES;
    
    if (!self.response) {
        self.response = [PGRKResponse responseWithNextPagination];
    }
    
    PGParams *params = [PGParams new];
    params[@"type"] = @(2);
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Message;
        config.params = params;
        config.keyPath = @"items";
        config.model = [PGMessage new];
        config.response = weakself.response;
    } paginationCompletion:^(PGRKResponse *response) {
        weakself.response = response;
        weakself.messages = response.dataArray;
        weakself.endFlag = response.pagination.endFlag;
        
        weakself.isPreloadingNextPage = NO;
    } failure:^(NSError *error) {
        weakself.error = error;
        
        weakself.isPreloadingNextPage = NO;
    }];
}

- (void)requestLikesMessages
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    
    self.isPreloadingNextPage = YES;
    
    if (!self.response) {
        self.response = [PGRKResponse responseWithNextPagination];
    }
    
    PGParams *params = [PGParams new];
    params[@"type"] = @(3);
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Message;
        config.params = params;
        config.keyPath = @"items";
        config.model = [PGMessage new];
        config.response = weakself.response;
    } paginationCompletion:^(PGRKResponse *response) {
        weakself.response = response;
        weakself.messages = response.dataArray;
        weakself.endFlag = response.pagination.endFlag;
        
        weakself.isPreloadingNextPage = NO;
    } failure:^(NSError *error) {
        weakself.error = error;
        
        weakself.isPreloadingNextPage = NO;
    }];
}

- (void)sendReplyComment:(NSString *)content commentId:(NSString *)commentId completion:(void (^)(BOOL))completion
{
    if (commentId && commentId.length > 0) {
        PGParams *params = [PGParams new];
        params[@"content"] = content;
        
        PGWeakSelf(self);
        [self.apiClient pg_makePostRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Comment_Reply;
            config.keyPath = nil;
            config.params = params;
            config.pattern = @{@"commentId":commentId};
        } completion:^(id response) {
            if (completion) {
                completion(YES);
            }
        } failure:^(NSError *error) {
            if (completion) {
                completion(NO);
            }
            weakself.error = error;
        }];
    } else {
        if (completion) {
            completion(NO);
        }
    }
}

@end
