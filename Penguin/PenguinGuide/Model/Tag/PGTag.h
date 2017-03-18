//
//  PGTag.h
//  Penguin
//
//  Created by Jing Dai on 9/19/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>

@interface PGTag : PGRKModel

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *name;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *tagId;

@end
