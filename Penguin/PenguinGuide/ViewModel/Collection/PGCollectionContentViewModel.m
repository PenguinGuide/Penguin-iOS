//
//  PGCollectionContentViewModel.m
//  Penguin
//
//  Created by Jing Dai on 30/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCollectionContentViewModel.h"

@interface PGCollectionContentViewModel ()

@property (nonatomic, strong, readwrite) NSArray *articles;

@end

@implementation PGCollectionContentViewModel

- (void)requestData
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    
    self.isPreloadingNextPage = YES;
    
    if (!self.response) {
        self.response = [[PGRKResponse alloc] init];
        self.response.pagination.needPerformingBatchUpdate = NO;
        self.response.pagination.paginationKey = @"cursor";
    }
    
    PGParams *params = [PGParams new];
    params[ParamsPerPage] = @10;
    params[ParamsPageCursor] = self.response.pagination.cursor;
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Collection_Articles;
        config.keyPath = @"items";
        config.params = params;
        config.model = [PGArticleBanner new];
        config.response = weakself.response;
    } paginationCompletion:^(PGRKResponse *response) {
        weakself.articles = response.dataArray;
        weakself.response = response;
        weakself.endFlag = weakself.response.pagination.endFlag;
        
        weakself.isPreloadingNextPage = NO;
    } failure:^(NSError *error) {
        weakself.error = error;
        
        weakself.isPreloadingNextPage = NO;
    }];
}

- (void)collectArticle:(NSString *)articleId completion:(void (^)(BOOL success))completion
{
    if (articleId && articleId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makePutRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Collect;
            config.keyPath = nil;
            config.pattern = @{@"articleId":articleId};
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

- (void)disCollectArticle:(NSString *)articleId index:(NSInteger)index completion:(void (^)(BOOL success))completion
{
    if (articleId && articleId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makeDeleteRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Collect;
            config.keyPath = nil;
            config.pattern = @{@"articleId":articleId};
        } completion:^(id response) {
            NSMutableArray *collectionsArray = [NSMutableArray arrayWithArray:weakself.articles];
            if (index < collectionsArray.count) {
                [collectionsArray removeObjectAtIndex:index];
                weakself.articles = [NSArray arrayWithArray:collectionsArray];
            }
            if (weakself.articles.count == 0) {
                weakself.endFlag = YES;
            } else {
                weakself.endFlag = NO;
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
    } else {
        if (completion) {
            completion(NO);
        }
    }
}

@end
