//
//  PGHomeViewModel.h
//  Penguin
//
//  Created by Jing Dai on 7/10/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"

@interface PGHomeViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *recommendsArray;
@property (nonatomic, strong, readonly) NSArray *channelsArray;
@property (nonatomic, strong, readonly) NSArray *feedsArray;
@property (nonatomic, strong, readonly) NSIndexSet *nextPageIndexSet;

- (void)requestFeeds;

@end
