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
@property (nonatomic, strong) NSString *sex;
@property (nonatomic, strong) NSString *birthday;
@property (nonatomic, strong) NSString *phoneNumber;
@property (nonatomic, strong) NSString *location;
@property (nonatomic, strong) NSString *collectionCount;
@property (nonatomic, assign) BOOL hasNewMessage;
@property (nonatomic, assign) BOOL weixinBinded;
@property (nonatomic, assign) BOOL weiboBinded;
@property (nonatomic, assign) BOOL hasPassword;

@end
