//
//  PGArticle.h
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>
#import "PGTag.h"
#import "PGImageBanner.h"

@interface PGArticle : PGRKModel

@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *subTitle;
@property (nonatomic, strong) NSString *author;
@property (nonatomic, strong) NSString *designer;
@property (nonatomic, strong) NSString *desc;
@property (nonatomic, strong) NSString *channel;
@property (nonatomic, strong) NSString *date;
@property (nonatomic, strong) NSString *shareUrl;
@property (nonatomic, assign) BOOL isLiked;
@property (nonatomic, assign) BOOL isCollected;
@property (nonatomic, strong) NSArray *tagsArray;
@property (nonatomic, strong) NSArray *relatedArticlesArray;

@end
