//
//  PGArticleViewModel.m
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleViewModel.h"

@interface PGArticleViewModel ()

@end

@implementation PGArticleViewModel

- (void)requestData
{
//    __block NSString *fileName = [NSString stringWithFormat:@"pg_article_%@.json", @"1"];
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Article;
        config.keyPath = nil;
        config.model = [PGArticle new];
        config.pattern = @{@"articleId":weakself.articleId};
//        config.isMockAPI = YES;
//        config.mockFileName = fileName;
    } completion:^(id response) {
        weakself.article = [response firstObject];
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

- (void)requestComments
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Article_Hot_Comments;
        config.keyPath = nil;
        config.model = [PGComment new];
        config.pattern = @{@"articleId":weakself.articleId};
    } completion:^(id response) {
        weakself.commentsArray = response;
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

- (void)sendComment:(NSString *)content completion:(void (^)(BOOL))completion
{
    PGParams *params = [PGParams new];
    params[@"content"] = content;
    
    PGWeakSelf(self);
    [self.apiClient pg_makePostRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Article_Comments;
        config.keyPath = nil;
        config.params = params;
        config.pattern = @{@"articleId":weakself.articleId};
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
