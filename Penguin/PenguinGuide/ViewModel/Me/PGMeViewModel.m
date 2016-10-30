//
//  PGMeViewModel.m
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMeViewModel.h"

@interface PGMeViewModel ()

@property (nonatomic, strong, readwrite) PGMe *me;

@end

@implementation PGMeViewModel

- (void)requestData
{
    if (PGGlobal.userId && PGGlobal.userId.length > 0) {
        PGParams *params = [PGParams new];
        
        PGWeakSelf(self);
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Me;
            config.params = params;
            config.model = [PGMe new];
            config.pattern = @{@"userId":PGGlobal.userId};
            config.keyPath = nil;
        } completion:^(id response) {
            weakself.me = [response firstObject];
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

@end
