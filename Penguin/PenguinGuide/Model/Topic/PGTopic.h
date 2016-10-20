//
//  PGTopic.h
//  Penguin
//
//  Created by Jing Dai on 9/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>
#import "PGArticleBanner.h"
#import "PGGood.h"

@interface PGTopic : PGRKModel

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSArray *articlesArray;
@property (nonatomic, strong) NSArray *goodsArray;

@end
