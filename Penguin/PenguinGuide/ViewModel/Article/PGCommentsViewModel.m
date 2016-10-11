//
//  PGCommentsViewModel.m
//  Penguin
//
//  Created by Jing Dai on 11/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCommentsViewModel.h"

@interface PGCommentsViewModel ()

@property (nonatomic, strong, readwrite) NSArray *commentsArray;

@end

@implementation PGCommentsViewModel

- (void)requestData
{
    PGWeakSelf(self);
    
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Comments;
        config.keyPath = @"items";
        config.model = [PGComment new];
        config.isMockAPI = YES;
        config.mockFileName = @"pg_comments.json";
    } completion:^(id response) {
        weakself.commentsArray = response;
    } failure:^(NSError *error) {
        
    }];
}

@end
