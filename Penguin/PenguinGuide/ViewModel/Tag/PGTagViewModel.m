//
//  PGTagViewModel.m
//  Penguin
//
//  Created by Jing Dai on 09/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTagViewModel.h"

@interface PGTagViewModel ()

@property (nonatomic, strong, readwrite) NSString *tagId;
@property (nonatomic, strong, readwrite) NSString *tagName;
@property (nonatomic, strong, readwrite) NSString *tagDesc;
@property (nonatomic, strong, readwrite) NSString *tagImage;
@property (nonatomic, strong, readwrite) NSArray *hotArticlesArray;
@property (nonatomic, strong, readwrite) NSArray *allArticlesArray;

@end

@implementation PGTagViewModel

- (void)requestTagWithId:(NSString *)tagId
{
    self.tagId = tagId;
    
    if (!self.response) {
        self.response = [[PGRKResponse alloc] init];
        self.response.pagination.needPerformingBatchUpdate = NO;
        self.response.pagination.paginateSections = NO;
        self.response.pagination.paginationKey = @"cursor";
    }
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Tag;
        config.pattern = @{@"tagId":tagId};
        config.keyPath = nil;
    } completion:^(id response) {
        NSDictionary *responseDict = [response firstObject];
        if (responseDict && [responseDict isKindOfClass:[NSDictionary class]]) {
            if (responseDict[@"tag_name"]) {
                weakself.tagName = responseDict[@"tag_name"];
            }
            if (responseDict[@"tag_image"]) {
                weakself.tagImage = responseDict[@"tag_image"];
            }
            if (responseDict[@"description"]) {
                weakself.tagDesc = responseDict[@"description"];
            }
            if (responseDict[@"hot_articles"] && [responseDict[@"hot_articles"] isKindOfClass:[NSArray class]]) {
                weakself.hotArticlesArray = [PGArticleBanner modelsFromArray:responseDict[@"hot_articles"]];
            }
            if (responseDict[@"cursor"]) {
                weakself.response.pagination.cursor = responseDict[@"cursor"];
            }
            if (responseDict[@"items"] && [responseDict[@"items"] isKindOfClass:[NSArray class]]) {
                weakself.allArticlesArray = [PGArticleBanner modelsFromArray:responseDict[@"items"]];
                weakself.response.dataArray = weakself.allArticlesArray;
            }
        }
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

- (void)loadNextPage
{
    if (self.isPreloadingNextPage || self.endFlag) {
        return;
    }
    if (!self.tagId) {
        return;
    }
    
    self.isPreloadingNextPage = YES;
    
    if (!self.response) {
        self.response = [[PGRKResponse alloc] init];
        self.response.pagination.needPerformingBatchUpdate = NO;
        self.response.pagination.paginateSections = NO;
        self.response.pagination.paginationKey = @"cursor";
    }
    
    PGParams *params = [PGParams new];
    params[ParamsPerPage] = @10;
    params[ParamsPageCursor] = self.response.pagination.cursor;
    
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Tag;
        config.pattern = @{@"tagId":weakself.tagId};
        config.keyPath = @"items";
        config.model = [PGArticleBanner new];
        config.params = params;
        config.response = weakself.response;
    } paginationCompletion:^(PGRKResponse *response) {
        weakself.response = response;
        weakself.allArticlesArray = response.dataArray;
        weakself.endFlag = response.pagination.endFlag;
        
        weakself.isPreloadingNextPage = NO;
    } failure:^(NSError *error) {
        weakself.error = error;
        
        weakself.isPreloadingNextPage = NO;
    }];
}

@end
