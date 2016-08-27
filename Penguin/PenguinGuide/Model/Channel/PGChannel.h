//
//  PGChannel.h
//  Penguin
//
//  Created by Jing Dai on 8/26/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>
#import "PGChannelCategory.h"

@interface PGChannel : PGRKModel

@property (nonatomic, strong) NSString *totalArticles;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSArray *categoriesArray;

@end
