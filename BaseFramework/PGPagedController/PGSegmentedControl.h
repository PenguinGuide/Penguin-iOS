//
//  PGSegmentedControl.h
//  Penguin
//
//  Created by Jing Dai on 24/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedController.h"

@interface PGSegmentedControl : UIControl

@property (nonatomic, weak) PGPagedController *pagedController;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat margin;

- (void)reloadWithTitles:(NSArray *)titles Class:(Class)SelectedViewClass;
- (void)scrollToPage:(NSInteger)page;

@end
