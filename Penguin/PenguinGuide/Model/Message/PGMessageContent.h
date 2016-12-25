//
//  PGMessageContent.h
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>

@interface PGMessageContent : PGRKModel

@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *content;
@property (nonatomic, strong) NSString *replyContent;
@property (nonatomic, strong) NSString *replyId;
@property (nonatomic, strong) NSString *nickname;

@end
