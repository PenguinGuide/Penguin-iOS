//
//  PGMessageViewModel.m
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGMessageViewModel.h"

@interface PGMessageViewModel ()

@property (nonatomic, strong, readwrite) NSDictionary *countsDict;

@end

@implementation PGMessageViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Message_Counts;
        config.keyPath = nil;
    } completion:^(id response) {
        weakself.countsDict = [response firstObject];
    } failure:^(NSError *error) {
        weakself.error = error;
    }];
}

@end
