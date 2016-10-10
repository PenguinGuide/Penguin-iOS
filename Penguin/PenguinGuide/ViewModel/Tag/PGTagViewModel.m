//
//  PGTagViewModel.m
//  Penguin
//
//  Created by Jing Dai on 09/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTagViewModel.h"

@interface PGTagViewModel ()

@property (nonatomic, strong, readwrite) NSArray *feedsArray;
@property (nonatomic, strong, readwrite) NSString *tagName;

@end

@implementation PGTagViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Tag;
        config.keyPath = nil;
        config.isMockAPI = YES;
        config.mockFileName = @"pg_tag_tagid.json";
    } completion:^(id response) {
        if (response[@"name"]) {
            weakself.tagName = response[@"name"];
        }
        if (response[@"items"] && [response[@"items"] isKindOfClass:[NSArray class]]) {
            weakself.feedsArray = [PGArticleBanner modelsFromArray:response[@"items"]];
        }
    } failure:^(NSError *error) {
        
    }];
}

@end
