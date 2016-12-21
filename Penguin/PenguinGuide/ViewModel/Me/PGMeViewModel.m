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
        PGWeakSelf(self);
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Me_Info;
            config.model = [PGMe new];
            config.keyPath = nil;
        } completion:^(id response) {
            weakself.me = [response firstObject];
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

- (void)requestDetails
{
    if (PGGlobal.userId && PGGlobal.userId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Me;
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

- (void)readMessages:(void (^)(BOOL success))completion
{
    if (PGGlobal.userId && PGGlobal.userId.length > 0) {
        [self.apiClient pg_makePostRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Message_Read;
            config.keyPath = nil;
        } completion:^(id response) {
            if (completion) {
                completion(YES);
            }
            [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_UPDATE_ME object:nil];
        } failure:^(NSError *error) {
            if (completion) {
                completion(NO);
            }
        }];
    }
}

@end
