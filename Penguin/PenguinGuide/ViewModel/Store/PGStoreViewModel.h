//
//  PGStoreViewModel.h
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"

@interface PGStoreViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *recommendsArray;
@property (nonatomic, strong, readonly) NSArray *categoriesArray;
@property (nonatomic, strong, readonly) NSArray *feedsArray;

- (void)requestFeeds;

@end
