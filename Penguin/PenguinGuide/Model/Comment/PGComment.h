//
//  PGComment.h
//  Penguin
//
//  Created by Jing Dai on 21/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>
#import "PGUser.h"

@interface PGComment : PGRKModel

@property (nonatomic, assign) NSInteger likesCount;
@property (nonatomic, assign) BOOL liked;
@property (nonatomic, assign) BOOL replyDeleted;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) NSString *commentId;
@property (nonatomic, assign) CGSize commentSize;

@property (nonatomic, strong) PGUser *user;

@property (nonatomic, strong) PGComment *replyComment;

@end
