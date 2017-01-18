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
@property (nonatomic, strong, readwrite) NSArray *nextPageIndexes;
@property (nonatomic, strong, readwrite) NSString *articleId;

@end

@implementation PGCommentsViewModel

- (void)requestComments:(NSString *)articleId
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    if (articleId && articleId.length > 0) {
        
        self.isPreloadingNextPage = YES;
        
        if (!self.response) {
            self.response = [PGRKResponse responseWithNextPagination];
        }
        
        PGWeakSelf(self);
        
        self.articleId = articleId;
        
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Comments;
            config.keyPath = @"items";
            config.model = [PGComment new];
            config.pattern = @{@"articleId":articleId};
            config.response = weakself.response;
        } paginationCompletion:^(PGRKResponse *response) {
            weakself.response = response;
            weakself.commentsArray = response.dataArray;
            weakself.endFlag = response.pagination.endFlag;
            
            weakself.isPreloadingNextPage = NO;
        } failure:^(NSError *error) {
            weakself.error = error;
            
            weakself.isPreloadingNextPage = NO;
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

- (void)likeComment:(NSString *)commentId completion:(void (^)(BOOL success))completion
{
    if (commentId && commentId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makePutRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Comment_Like;
            config.keyPath = nil;
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
    }
}

- (void)dislikeComment:(NSString *)commentId completion:(void (^)(BOOL success))completion
{
    if (commentId && commentId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makeDeleteRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Comment_Like;
            config.keyPath = nil;
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
    }
}

- (void)deleteComment:(NSString *)commentId index:(NSInteger)index completion:(void (^)(BOOL success))completion
{
    if (commentId && commentId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makeDeleteRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Comment;
            config.keyPath = nil;
            config.pattern = @{@"commentId":commentId};
        } completion:^(id response) {
            NSMutableArray *dataArray = [NSMutableArray arrayWithArray:weakself.commentsArray];
            if (index < dataArray.count) {
                [dataArray removeObjectAtIndex:index];
                weakself.commentsArray = [NSArray arrayWithArray:dataArray];
            }
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
}

@end
