//
//  PGCollectionContentViewModel.h
//  Penguin
//
//  Created by Jing Dai on 30/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGArticleBanner.h"

@interface PGCollectionContentViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *articles;

- (void)requestData;

@end
