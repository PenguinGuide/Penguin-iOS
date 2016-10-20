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

- (void)requestComments:(NSString *)articleId
{
    if (articleId && articleId.length > 0) {
        PGWeakSelf(self);
        
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Article_Comments;
            config.keyPath = @"items";
            config.model = [PGComment new];
            config.pattern = @{@"articleId":articleId};
        } completion:^(id response) {
            weakself.commentsArray = response;
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

@end
