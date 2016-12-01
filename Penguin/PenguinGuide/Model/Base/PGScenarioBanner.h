//
//  PGScenarioBanner.h
//  Penguin
//
//  Created by Jing Dai on 9/1/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>

@interface PGScenarioBanner : PGRKModel

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *scenarioId;
@property (nonatomic, strong) NSString *link;
@property (nonatomic, strong) NSString *type;

@end
