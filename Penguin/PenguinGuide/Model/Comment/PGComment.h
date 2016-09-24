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

@property (nonatomic, strong) NSString *likes;
@property (nonatomic) BOOL liked;
@property (nonatomic, strong) NSString *comment;
@property (nonatomic, strong) NSString *reply;
@property (nonatomic, strong) NSString *replyTo;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) PGUser *user;

@end
