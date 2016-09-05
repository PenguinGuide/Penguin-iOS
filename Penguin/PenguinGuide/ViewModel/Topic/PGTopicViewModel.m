//
//  PGTopicViewModel.m
//  Penguin
//
//  Created by Jing Dai on 9/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTopicViewModel.h"

@interface PGTopicViewModel ()

@property (nonatomic, strong, readwrite) PGTopic *topic;

@end

@implementation PGTopicViewModel

- (void)requestData
{
    PGWeakSelf(self);
    [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
        config.route = PG_Topic;
        config.keyPath = @"data";
        config.model = [PGTopic new];
        config.isMockAPI = YES;
        config.mockFileName = @"v1_topic_topicid.json";
    } completion:^(id response) {
        weakself.topic = [response firstObject];
    } failure:^(NSError *error) {
        
    }];
}

@end
