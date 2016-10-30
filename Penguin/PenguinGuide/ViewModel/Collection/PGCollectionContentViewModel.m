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

- (void)requestArticles:(NSString *)channelId
{
    if (channelId && channelId.length > 0) {
        PGParams *params = [PGParams new];
        params[@"channel_id"] = channelId;
        
        PGWeakSelf(self);
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Channel_Collection_Articles;
            config.params = params;
            config.keyPath = nil;
            config.model = [PGArticleBanner new];
        } completion:^(id response) {
            weakself.articles = response;
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

@end
