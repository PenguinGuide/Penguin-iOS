//
//  PGHomeViewModel.m
//  Penguin
//
//  Created by Jing Dai on 7/10/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGHomeViewModel.h"

#import "PGCarouselBanner.h"
#import "PGArticleBanner.h"

@interface PGHomeViewModel ()

@property (nonatomic, strong, readwrite) NSArray *dataArray;

@end

@implementation PGHomeViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Home_HomeFeeds;
        config.keyPath = @"data";
        config.isMockAPI = YES;
        config.mockFileName = @"v1_homefeeds.json";
    } completion:^(id response) {
        if (response[@"data"] && [response[@"data"] isKindOfClass:[NSArray class]]) {
            NSMutableArray *models = [NSMutableArray new];
            for (NSDictionary *dict in response[@"data"]) {
                if (dict[@"type"]) {
                    if ([dict[@"type"] isEqualToString:@"carousel"]) {
                        PGCarouselBanner *carouseBanner = [PGCarouselBanner modelFromDictionary:dict];
                        if (carouseBanner) {
                            [models addObject:carouseBanner];
                        }
                    }
                    if ([dict[@"type"] isEqualToString:@"article"]) {
                        PGArticleBanner *articleBanner = [PGArticleBanner modelFromDictionary:dict];
                        if (articleBanner) {
                            [models addObject:articleBanner];
                        }
                    }
                }
            }
            weakself.dataArray = [NSArray arrayWithArray:models];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
