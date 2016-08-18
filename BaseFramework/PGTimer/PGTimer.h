//
//  PGTimer.h
//  Penguin
//
//  Created by Jing Dai on 8/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGTimer : NSObject

- (PGTimer *)initWithTimerInterval:(NSTimeInterval)interval
                            target:(id)target
                          selector:(SEL)selector
                          userInfo:(id)userInfo
                           repeats:(BOOL)repeats;

+ (PGTimer *)scheduledTimerWithTimerInterval:(NSTimeInterval)interval
                                      target:(id)target
                                    selector:(SEL)selector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats;

- (void)fire;
- (void)invalidate;

@end
