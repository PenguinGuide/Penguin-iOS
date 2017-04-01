//
//  PGExploreViewModel.m
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static NSString *ScenarioTypeCategory = @"4";
static NSString *ScenarioTypeLevel = @"3";
static NSString *ScenarioTypeGroup = @"2";

#import "PGExploreViewModel.h"

@interface PGExploreViewModel ()

@property (nonatomic, strong, readwrite) NSArray *hotArticlesArray;
@property (nonatomic, strong, readwrite) PGArticleBanner *currentArticle;
@property (nonatomic, strong, readwrite) NSArray *tagsArray;
@property (nonatomic, strong, readwrite) NSArray *articlesArray;

@end

@implementation PGExploreViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Explore_Recommends;
        config.keyPath = nil;
    } completion:^(id response) {
        NSDictionary *responseDict = [response firstObject];
        if ([responseDict isKindOfClass:[NSDictionary class]]) {
            if (responseDict[@"daily"] && [responseDict[@"daily"] isKindOfClass:[NSDictionary class]]) {
                weakself.currentArticle = [PGArticleBanner modelFromDictionary:responseDict[@"daily"]];
            }
            if (responseDict[@"tags"] && [responseDict[@"tags"] isKindOfClass:[NSArray class]]) {
                weakself.tagsArray = [PGTag modelsFromArray:responseDict[@"tags"]];
            }
            if (responseDict[@"hots"] && [responseDict[@"hots"] isKindOfClass:[NSArray class]]) {
                weakself.hotArticlesArray = [PGArticleBanner modelsFromArray:responseDict[@"hots"]];
            }
        }
        [weakself requestArticles];
    } failure:^(NSError *error) {
        [weakself requestArticles];
    }];
}

- (void)requestArticles
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    
    self.isPreloadingNextPage = YES;
    
    if (!self.response) {
        self.response = [[PGRKResponse alloc] init];
        self.response.pagination.paginationKey = @"cursor";
    }
    
    PGParams *params = [PGParams new];
    params[ParamsPerPage] = @10;
    params[ParamsPageCursor] = self.response.pagination.cursor;
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Explore_Feeds;
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
    self.endFlag = NO;
    self.isPreloadingNextPage = NO;
    self.response = nil;
}

@end
