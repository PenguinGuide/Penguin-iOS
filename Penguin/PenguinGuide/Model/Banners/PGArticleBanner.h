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
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *coverTitle;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *channelIcon;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *likesCount;
@property (nonatomic, strong) NSString *commentsCount;
@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, assign) BOOL isCollected;
@property (nonatomic, assign) BOOL isNew;
@property (nonatomic, assign) BOOL isRecommendGood;
@property (nonatomic, assign) BOOL isRecommendResturant;

@end
