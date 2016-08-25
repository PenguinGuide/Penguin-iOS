//
//  PGGood.h
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>

@interface PGGood : PGRKModel

@property (nonatomic, strong) NSString *discountPrice;
@property (nonatomic, strong) NSString *originalPrice;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *unit;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, assign) BOOL isNew;

@end
