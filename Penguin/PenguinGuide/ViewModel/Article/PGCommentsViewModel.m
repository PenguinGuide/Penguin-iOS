//
//  PGCommentsViewModel.m
//  Penguin
//
//  Created by Jing Dai on 11/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCommentsViewModel.h"

@interface PGCommentsViewModel ()

@property (nonatomic, strong, readwrite) NSArray *commentsArray;
@property (nonatomic, strong, readwrite) NSString *articleId;

@end

@implementation PGCommentsViewModel

- (void)requestComments:(NSString *)articleId
{
    if (articleId && articleId.length > 0) {
        PGWeakSelf(self);
        
        self.articleId = articleId;
        self.page = 1;
        
        PGParams *params = [PGParams new];
        params[@"page"] = @(self.page);
        
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Comments;
            config.params = params;
            config.keyPath = @"items";
            config.model = [PGComment new];
            config.pattern = @{@"articleId":articleId};
        } completion:^(id response) {
            if ([response count] > 0) {
                weakself.page++;
            }
            weakself.commentsArray = response;
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

- (void)loadNextPage
{
    if (self.articleId && self.articleId.length > 0) {
        PGWeakSelf(self);
        
        PGParams *params = [PGParams new];
        params[@"page"] = @(self.page);
        
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Comments;
            config.params = params;
            config.keyPath = @"items";
            config.model = [PGComment new];
            config.pattern = @{@"articleId":weakself.articleId};
        } completion:^(id response) {
            NSMutableArray *comments = [NSMutableArray arrayWithArray:weakself.commentsArray];
            if ([response count] > 0) {
                weakself.page++;
                [comments addObjectsFromArray:response];
            }
            weakself.commentsArray = [NSArray arrayWithArray:comments];
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
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
