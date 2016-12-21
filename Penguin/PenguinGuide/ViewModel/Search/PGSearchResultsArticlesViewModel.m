//
//  PGSearchResultsArticlesViewModel.m
//  Penguin
//
//  Created by Kobe Dai on 15/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSearchResultsArticlesViewModel.h"

@interface PGSearchResultsArticlesViewModel ()

@property (nonatomic, strong, readwrite) NSArray *articlesArray;

@end

@implementation PGSearchResultsArticlesViewModel

- (void)requestArticles:(NSString *)keyword
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    
    self.isPreloadingNextPage = YES;
    
    if (!self.response) {
        self.response = [[PGRKResponse alloc] init];
        self.response.pagination.needPerformingBatchUpdate = NO;
        self.response.pagination.paginateSections = NO;
        self.response.pagination.paginationKey = @"next";
    }
    
    PGParams *params = [PGParams new];
    params[@"type"] = @"article";
    params[@"keyword"] = keyword;
    params[@"per_page"] = @(10);
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Search;
        config.params = params;
        config.keyPath = @"items";
        config.model = [PGArticleBanner new];
        config.response = weakself.response;
    } paginationCompletion:^(PGRKResponse *response) {
        weakself.response = response;
        weakself.articlesArray = response.dataArray;
        weakself.endFlag = response.pagination.endFlag;
        
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

- (void)disCollectArticle:(NSString *)articleId completion:(void (^)(BOOL success))completion
{
    if (articleId && articleId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makeDeleteRequest:^(PGRKRequestConfig *config) {
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

- (void)clearPagination
{
    self.response = nil;
    self.endFlag = NO;
    self.isPreloadingNextPage = NO;
}

@end
