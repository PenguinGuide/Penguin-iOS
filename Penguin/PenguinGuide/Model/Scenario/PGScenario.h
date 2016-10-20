//
//  PGScenario.h
//  Penguin
//
//  Created by Jing Dai on 8/31/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>
#import "PGScenarioCategory.h"

@interface PGScenario : PGRKModel

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSArray *categoriesArray;

@end
