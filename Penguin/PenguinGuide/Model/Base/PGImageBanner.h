//
//  PGImageBanner.h
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>

@interface PGImageBanner : PGRKModel

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *type;

@end
