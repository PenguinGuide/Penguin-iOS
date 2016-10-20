//
//  PGTagViewModel.h
//  Penguin
//
//  Created by Jing Dai on 09/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGArticleBanner.h"

@interface PGTagViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSString *tagName;
@property (nonatomic, strong, readonly) NSArray *feedsArray;

@end
