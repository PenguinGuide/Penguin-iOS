//
//  PGParserImageStorage.h
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGParserImageStorage : NSObject

@property (nonatomic, strong) NSString *image;
@property (nonatomic) CGFloat width;
@property (nonatomic) CGFloat height;
@property (nonatomic) BOOL isGIF;

@end
