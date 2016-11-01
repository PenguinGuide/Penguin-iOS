//
//  PGChannelViewModel.m
//  Penguin
//
//  Created by Jing Dai on 8/26/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGChannelViewModel.h"
#import "PGArticleBanner.h"

@interface PGChannelViewModel ()

@property (nonatomic, strong, readwrite) PGChannel *channel;
@property (nonatomic, strong, readwrite) NSArray *articlesArray;
@property (nonatomic, strong, readwrite) NSString *channelId;

@end

@implementation PGChannelViewModel

- (void)requestChannel:(NSString *)channelId
{
    self.channelId = channelId;
    // FIXME: data without "result" key, completion & failure blocks will not be called
    if (self.channelId && self.channelId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Channel;
            config.pattern = @{@"channelId":weakself.channelId};
            config.model = [PGChannel new];
            config.keyPath = nil;
        } completion:^(id response) {
            weakself.channel = [response firstObject];
            if (weakself.channel.categoriesArray.count > 0) {
                PGChannelCategory *category = weakself.channel.categoriesArray.firstObject;
                [weakself requestArticles:category.categoryId];
            }
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

- (void)requestArticles:(NSString *)categoryId
{
    PGParams *params = [PGParams new];
    if (categoryId && categoryId.length > 0) {
        params[@"category_id"] = categoryId;
    }
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Channel_Category_Articles;
        config.params = params;
        config.pattern = @{@"channelId":weakself.channelId};
        config.model = [PGArticleBanner new];
        config.keyPath = @"items";
    } completion:^(id response) {
        weakself.articlesArray = response;
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

- (void)requestArticles:(NSString *)channelId categoryId:(NSString *)categoryId
{
    PGParams *params = [PGParams new];
    if (categoryId && categoryId.length > 0) {
        params[@"category_id"] = categoryId;
    }
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Channel_Category_Articles;
        config.params = params;
        config.pattern = @{@"channelId":channelId};
        config.model = [PGArticleBanner new];
        config.keyPath = @"items";
    } completion:^(id response) {
        weakself.articlesArray = response;
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

@end
