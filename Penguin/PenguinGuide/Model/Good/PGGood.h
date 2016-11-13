//
//  PGGood.h
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>
#import "PGImageBanner.h"
#import "PGTag.h"

@interface PGGood : PGRKModel

@property (nonatomic, strong) NSString *discountPrice;
@property (nonatomic, strong) NSString *originalPrice;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *startTime;
@property (nonatomic, strong) NSString *endTime;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *goodId;
@property (nonatomic, strong) NSString *goodTaobaoId;

@property (nonatomic, strong) NSArray *bannersArray;
@property (nonatomic, strong) NSArray *tagsArray;
@property (nonatomic, strong) NSArray *relatedArticlesArray;

@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL isCollected;

@end
