//
//  PGPagedController.h
//  Penguin
//
//  Created by Jing Dai on 24/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PGSegmentedControl;

@interface PGPagedController : UIViewController

@property (nonatomic, assign) BOOL disableScrolling;

@property (nonatomic, strong) PGSegmentedControl *segmentedControl;

@property (nonatomic, strong, readonly) NSArray *viewControllers;
@property (nonatomic, assign, readonly) CGFloat segmentHeight;
@property (nonatomic, assign, readonly) NSInteger currentPage;

- (id)initWithViewControllers:(NSArray *)viewControllers segmentHeight:(CGFloat)segmentHeight;

- (void)reload:(NSArray *)viewControllers;

- (void)scrollToPage:(NSInteger)page;

@end
