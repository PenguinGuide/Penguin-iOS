//
//  PGMe.h
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>

@interface PGMe : PGRKModel

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *userId;
@property (nonatomic, strong) NSString *session;
@property (nonatomic, assign) NSInteger sex;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *collectionCount;
@property (nonatomic, strong) NSString *messageCount;

@end
