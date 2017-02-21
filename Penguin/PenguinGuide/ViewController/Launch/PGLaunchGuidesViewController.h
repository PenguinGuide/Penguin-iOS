//
//  PGLaunchGuidesViewController.h
//  Penguin
//
//  Created by Kobe Dai on 16/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"

@interface PGLaunchGuidesViewController : PGBaseViewController

@property (nonatomic, copy) void (^completionBlock)();

- (id)initWithImages:(NSArray *)imagesArray;

@end
