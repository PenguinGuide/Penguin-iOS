//
//  PGCollection.h
//  Penguin
//
//  Created by Jing Dai on 30/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>

@interface PGCollection : PGRKModel

@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *channelId;
@property (nonatomic, strong) NSString *count;

@end
