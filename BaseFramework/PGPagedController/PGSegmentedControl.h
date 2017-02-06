//
//  PGSegmentedControl.h
//  Penguin
//
//  Created by Jing Dai on 24/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedController.h"
#import "PGSegmentedControlConfig.h"

@interface PGSegmentedControl : UIControl

@property (nonatomic, weak) PGPagedController *pagedController;

@property (nonatomic, strong) NSArray *segmentTitles;
@property (nonatomic, strong) PGSegmentedControlConfig *config;

- (id)initWithSegmentTitles:(NSArray *)segmentTitles;

- (void)reloadSegmentTitles:(NSArray *)segmentTitles;
- (void)scrollToPage:(NSInteger)page;

@end
