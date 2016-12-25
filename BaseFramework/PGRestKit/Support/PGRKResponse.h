//
//  PGRKResponse.h
//  Penguin
//
//  Created by Jing Dai on 17/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGRKPagination.h"

@interface PGRKResponse : NSObject

@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, strong) PGRKPagination *pagination;

+ (PGRKResponse *)responseWithNextPagination;

@end
