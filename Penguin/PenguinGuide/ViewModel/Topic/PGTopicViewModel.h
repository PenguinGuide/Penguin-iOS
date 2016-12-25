//
//  PGTopicViewModel.h
//  Penguin
//
//  Created by Jing Dai on 9/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGTopic.h"

@interface PGTopicViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) PGTopic *topic;

- (void)requestTopic:(NSString *)topicId;

@end
