//
//  PGArticleViewModel.m
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleViewModel.h"

@interface PGArticleViewModel ()

@end

@implementation PGArticleViewModel

- (void)requestData
{
//    __block NSString *fileName = [NSString stringWithFormat:@"pg_article_%@.json", @"1"];
    
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Article;
        config.keyPath = nil;
        config.model = [PGArticle new];
        config.pattern = @{@"articleId": weakself.articleId ? weakself.articleId : @""};
//        config.isMockAPI = YES;
//        config.mockFileName = fileName;
    } completion:^(id response) {
        weakself.article = [response firstObject];
    } failure:^(NSError *error) {
        
    }];
}

- (void)requestComments
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
