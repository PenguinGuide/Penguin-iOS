//
//  PGHistoryContent.h
//  Penguin
//
//  Created by Jing Dai on 31/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>

@interface PGHistoryContent : PGRKModel

@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *articleTitle;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *articleId;

@end
