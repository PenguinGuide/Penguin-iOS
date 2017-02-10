//
//  PGSegmentedControlConfig.m
//  Penguin
//
//  Created by Jing Dai on 04/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGSegmentedControlConfig.h"

@implementation PGSegmentedControlConfig

- (id)init
{
    if (self = [super init]) {
        self.titles = [NSArray new];
        self.segmentHeight = 60.f;
        self.backgroundColor = [UIColor whiteColor];
        self.textColor = [UIColor colorWithRed:175.f/256.f green:189.f/256.f blue:189.f/256.f alpha:1.f];
        self.selectedTextColor = [UIColor blackColor];
        self.textFont = [UIFont systemFontOfSize:16.f weight:UIFontWeightBold];
        self.segmentPadding = 25.f;
        self.segmentMargin = 20.f;
        self.equalWidth = NO;
    }
    
    return self;
}

@end
