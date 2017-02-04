//
//  PGPagedController.h
//  Penguin
//
//  Created by Jing Dai on 24/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGPagedController : UIViewController

@property (nonatomic, strong) NSArray *viewControllers;
@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, strong) UIColor *backgroundColor;

@property (nonatomic, strong) UIColor *textColor;
@property (nonatomic, strong) UIColor *selectedTextColor;

@property (nonatomic, strong) UIFont *textFont;

@property (nonatomic, assign) CGFloat padding;
@property (nonatomic, assign) CGFloat margin;

@property (nonatomic, assign) CGFloat segmentHeight;
@property (nonatomic, assign) BOOL equalWidth;
@property (nonatomic, assign) BOOL disableScrolling;

@property (nonatomic, assign) Class SelectedViewClass;

@property (nonatomic, assign, readonly) NSInteger currentPage;

- (void)reload;

- (void)scrollToPage:(NSInteger)page;

@end
