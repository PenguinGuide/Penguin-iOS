//
//  UIViewController+PGPagedController.m
//  Penguin
//
//  Created by Jing Dai on 04/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "UIViewController+PGPagedController.h"
#import "PGSegmentedControl.h"
#import <objc/runtime.h>

static char SegmentedControl;
static char PagedController;

@interface UIViewController (PGPagedController)

@property (nonatomic, strong, readwrite) PGPagedController *pagedController;
@property (nonatomic, strong) PGSegmentedControl *segmentedControl;

@end

@implementation UIViewController (PGPagedController)

- (void)addPagedController:(CGRect)frame viewControllers:(NSArray *)viewControllers segmentConfig:(void (^)(PGSegmentedControlConfig *config))configBlock
{
    PGSegmentedControlConfig *config = [[PGSegmentedControlConfig alloc] init];
    configBlock(config);
    
    if (!self.pagedController) {
        self.pagedController = [[PGPagedController alloc] initWithViewControllers:viewControllers segmentHeight:config.segmentHeight];
        self.pagedController.view.frame = frame;
        if (config.equalWidth) {
            self.pagedController.disableScrolling = YES;
        }
    } else {
        [self.pagedController reload:viewControllers];
    }
    
    if (!self.segmentedControl) {
        // why use UIControl: http://www.tuicool.com/articles/B73AFj
        self.segmentedControl = [[PGSegmentedControl alloc] initWithConfig:config];
        self.pagedController.segmentedControl = self.segmentedControl;
        
        self.segmentedControl.pagedController = self.pagedController;
        self.segmentedControl.frame = CGRectMake(0, 0, self.view.frame.size.width, config.segmentHeight);
        [self.pagedController.view addSubview:self.segmentedControl];
    } else {
        [self.segmentedControl reload:config];
    }
    
    if (![self.childViewControllers containsObject:self.pagedController]) {
        [self.view addSubview:self.pagedController.view];
        [self addChildViewController:self.pagedController];
        [self.pagedController didMoveToParentViewController:self];
    }
}

- (void)setPagedController:(PGPagedController *)pagedController
{
    objc_setAssociatedObject(self, &PagedController, pagedController, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PGPagedController *)pagedController
{
    return objc_getAssociatedObject(self, &PagedController);
}

- (void)setSegmentedControl:(PGSegmentedControl *)segmentedControl
{
    objc_setAssociatedObject(self, &SegmentedControl, segmentedControl, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (PGSegmentedControl *)segmentedControl
{
    return objc_getAssociatedObject(self, &SegmentedControl);
}

@end
