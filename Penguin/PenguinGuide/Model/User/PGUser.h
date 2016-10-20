//
//  PGUser.h
//  Penguin
//
//  Created by Jing Dai on 21/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>

@interface PGUser : PGRKModel

@property (nonatomic, strong) NSString *nickname;
@property (nonatomic, strong) NSString *avatar;
@property (nonatomic, strong) NSString *userId;

@end
