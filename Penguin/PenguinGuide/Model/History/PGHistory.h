//
//  PGHistory.h
//  Penguin
//
//  Created by Jing Dai on 31/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>
#import "PGHistoryContent.h"

@interface PGHistory : PGRKModel

@property (nonatomic, strong) NSString *historyId;
@property (nonatomic, strong) NSString *time;
@property (nonatomic, strong) PGHistoryContent *content;

@end
