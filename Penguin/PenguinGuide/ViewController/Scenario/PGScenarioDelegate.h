//
//  PGScenarioDelegate.h
//  Penguin
//
//  Created by Kobe Dai on 27/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PGScenarioDelegate <NSObject>

@optional

- (void)showPageLoading;
- (void)dismissPageLoading;

@end
