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

#import "PGArticleBanner.h"
#import "PGScenarioBanner.h"

@interface PGExploreViewModel ()

@property (nonatomic, strong, readwrite) NSArray *recommendsArray;

@property (nonatomic, strong, readwrite) NSArray *scenariosArray;
@property (nonatomic, strong, readwrite) NSArray *categoriesArray;
@property (nonatomic, strong, readwrite) NSArray *levelsArray;
@property (nonatomic, strong, readwrite) NSArray *groupsArray;

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
        if (responseDict && [responseDict isKindOfClass:[NSDictionary class]]) {
            if (responseDict[@"banners"]) {
                weakself.recommendsArray = [PGImageBanner modelsFromArray:responseDict[@"banners"]];
            }
            if (responseDict[@"scenarios"]) {
                weakself.scenariosArray = [PGScenarioBanner modelsFromArray:responseDict[@"scenarios"]];
                
                NSPredicate *categoryPredicate = [NSPredicate predicateWithFormat:@"type == %@", ScenarioTypeCategory];
                NSPredicate *levelPredicate = [NSPredicate predicateWithFormat:@"type == %@", ScenarioTypeLevel];
                NSPredicate *groupPredicate = [NSPredicate predicateWithFormat:@"type == %@", ScenarioTypeGroup];
                
                weakself.categoriesArray = [weakself.scenariosArray filteredArrayUsingPredicate:categoryPredicate];
                weakself.levelsArray = [weakself.scenariosArray filteredArrayUsingPredicate:levelPredicate];
                weakself.groupsArray = [weakself.scenariosArray filteredArrayUsingPredicate:groupPredicate];
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

- (void)clearPagination
{
    self.endFlag = NO;
    self.isPreloadingNextPage = NO;
    self.response = nil;
}

@end
