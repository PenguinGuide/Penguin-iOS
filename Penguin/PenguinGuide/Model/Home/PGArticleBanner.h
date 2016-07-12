//
//  PGArticleBanner.h
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>
#import "PGImageBanner.h"

@interface PGArticleBanner : PGRKModel

@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSArray *banners;

@end
