//
//  PGArticleViewModel.m
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleViewModel.h"
#import "PGGood.h"
#import "PGParserSingleGoodStorage.h"
#import "PGParserGoodsCollectionStorage.h"

@interface PGArticleViewModel ()

@property (nonatomic, strong, readwrite) NSError *commentError;

@end

@implementation PGArticleViewModel

- (void)requestData
{
    if (self.articleId && self.articleId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article;
            config.keyPath = nil;
            config.model = [PGArticle new];
            config.pattern = @{@"articleId":weakself.articleId};
        } completion:^(id response) {
            weakself.article = [response firstObject];
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

- (void)requestGoods:(void (^)())completion
{
    if (self.paragraphsArray && self.paragraphsArray.count > 0) {
        __block dispatch_group_t group = dispatch_group_create();
        
        for (id storage in self.paragraphsArray) {
            if ([storage isKindOfClass:[PGParserSingleGoodStorage class]]) {
                __block PGParserSingleGoodStorage *singleGoodStorage = (PGParserSingleGoodStorage *)storage;
                if (singleGoodStorage.goodId && singleGoodStorage.goodId.length > 0) {
                    dispatch_group_enter(group);
                    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
                        config.route = PG_Good;
                        config.keyPath = nil;
                        config.pattern = @{@"goodId":singleGoodStorage.goodId};
                        config.model = [PGGood new];
                    } completion:^(id response) {
                        PGGood *good = [response firstObject];
                        singleGoodStorage.good = good;
                        dispatch_group_leave(group);
                    } failure:^(NSError *error) {
                        dispatch_group_leave(group);
                    }];
                }
            } else if ([storage isKindOfClass:[PGParserGoodsCollectionStorage class]]) {
                __block PGParserGoodsCollectionStorage *goodsCollectionStorage = (PGParserGoodsCollectionStorage *)storage;
                if (goodsCollectionStorage.collectionId && goodsCollectionStorage.collectionId.length > 0) {
                    dispatch_group_enter(group);
                    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
                        config.route = PG_Goods_Collection;
                        config.keyPath = nil;
                        config.pattern = @{@"collectionId":goodsCollectionStorage.collectionId};
                        config.model = [PGGood new];
                    } completion:^(id response) {
                        goodsCollectionStorage.goodsArray = response;
                        dispatch_group_leave(group);
                    } failure:^(NSError *error) {
                        dispatch_group_leave(group);
                    }];
                }
            }
        }
        
        dispatch_group_notify(group, dispatch_get_main_queue(), ^{
            if (completion) {
                completion();
            }
        });
    } else {
        if (completion) {
            completion();
        }
    }
}

- (void)likeArticle
{
    if (self.articleId && self.articleId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makePutRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Like;
            config.keyPath = nil;
            config.pattern = @{@"articleId":weakself.articleId};
        } completion:^(id response) {
            weakself.likeSuccess = YES;
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

- (void)dislikeArticle
{
    if (self.articleId && self.articleId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makeDeleteRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Like;
            config.keyPath = nil;
            config.pattern = @{@"articleId":weakself.articleId};
        } completion:^(id response) {
            weakself.dislikeSuccess = YES;
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

- (void)collectArticle
{
    if (self.articleId && self.articleId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makePutRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Collect;
            config.keyPath = nil;
            config.pattern = @{@"articleId":weakself.articleId};
        } completion:^(id response) {
            weakself.collectSuccess = YES;
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

- (void)discollectArticle
{
    if (self.articleId && self.articleId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makeDeleteRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Collect;
            config.keyPath = nil;
            config.pattern = @{@"articleId":weakself.articleId};
        } completion:^(id response) {
            weakself.discollectSuccess = YES;
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
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
        weakself.commentError = error;
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

- (void)likeComment:(NSString *)commentId completion:(void (^)(BOOL))completion
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

- (void)dislikeComment:(NSString *)commentId completion:(void (^)(BOOL))completion
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

- (void)reportComment:(NSString *)commentId completion:(void (^)(BOOL))completion
{
    if (commentId && commentId.length > 0) {
        
    }
}

@end
