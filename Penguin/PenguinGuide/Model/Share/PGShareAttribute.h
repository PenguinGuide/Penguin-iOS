//
//  PGShareItem.h
//  Penguin
//
//  Created by Jing Dai on 11/01/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGShareAttribute : NSObject

@property (nonatomic, strong) NSString *day;
@property (nonatomic, strong) NSString *month;
@property (nonatomic, strong) NSString *year;

@property (nonatomic, strong) NSString *text;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *url;

@property (nonatomic, strong) NSString *thumbnailImage;
@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) UIImage *shareViewImage;

@end
