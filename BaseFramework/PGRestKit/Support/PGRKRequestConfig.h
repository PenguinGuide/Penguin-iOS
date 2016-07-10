//
//  PGRKRequestConfig.h
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGRKParams.h"
#import "PGRKModel.h"

@interface PGRKRequestConfig : NSObject

@property (nonatomic, strong) NSString *route;
@property (nonatomic, strong) NSString *keyPath;
@property (nonatomic, strong) NSDictionary *pattern;
@property (nonatomic, strong) PGRKParams *params;
@property (nonatomic, strong) PGRKModel *model;

@end
