//
//  PGPagedController.h
//  Penguin
//
//  Created by Jing Dai on 24/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGPagedController : UIViewController

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, assign) BOOL equalWidth;
@property (nonatomic, assign) BOOL disableScrolling;

- (void)reloadWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles selectedViewClass:(Class)SelectedViewClass;

- (void)scrollToPage:(NSInteger)page;

@end
