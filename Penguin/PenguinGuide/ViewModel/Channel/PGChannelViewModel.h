//
//  PGChannelViewModel.h
//  Penguin
//
//  Created by Jing Dai on 8/26/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGChannel.h"

@interface PGChannelViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) PGChannel *channel;
@property (nonatomic, strong, readonly) NSArray *articlesArray;

- (void)setViewModelWithChannelId:(NSString *)channelId;

@end
