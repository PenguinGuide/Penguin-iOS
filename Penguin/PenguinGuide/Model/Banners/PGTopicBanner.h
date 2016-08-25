//
//  PGTopicBanner.h
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>

@interface PGTopicBanner : PGRKModel

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSArray *goodsArray;

@end
