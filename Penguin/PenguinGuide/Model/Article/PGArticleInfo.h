//
//  PGArticleInfo.h
//  Penguin
//
//  Created by Kobe Dai on 29/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>
#import "PGTag.h"
#import "PGArticleBanner.h"

@interface PGArticleInfo : PGRKModel

@property (nonatomic, assign) NSInteger likesCount;
@property (nonatomic, assign) NSInteger commentsCount;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) BOOL isCollected;
@property (nonatomic, strong) NSArray *tagsArray;
@property (nonatomic, strong) NSArray *relatedArticlesArray;

@end
