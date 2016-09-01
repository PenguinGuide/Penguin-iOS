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

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *type;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *category;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *readsCount;
@property (nonatomic, strong) NSString *commentsCount;

@end
