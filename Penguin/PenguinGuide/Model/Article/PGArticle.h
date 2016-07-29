//
//  PGArticle.h
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>

@interface PGArticle : PGRKModel

@property (nonatomic, strong) NSString *body;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *shareUrl;

@end
