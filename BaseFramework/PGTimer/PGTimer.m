//
//  PGTimer.m
//  Penguin
//
//  Created by Jing Dai on 8/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGTimer.h"

@interface PGTimer ()

@property (nonatomic, assign) NSTimeInterval interval;
@property (nonatomic, strong) id target;
@property (nonatomic, assign) SEL selector;
@property (nonatomic, strong) id userInfo;
@property (nonatomic, assign) BOOL repeats;

@property (nonatomic, assign) dispatch_source_t dispatchTimer;
@property (nonatomic, assign) dispatch_queue_t serialQueue;

@end

@implementation PGTimer

- (PGTimer *)initWithTimerInterval:(NSTimeInterval)interval
                            target:(id)target
                          selector:(SEL)selector
                          userInfo:(id)userInfo
                           repeats:(BOOL)repeats
{
    // http://my.oschina.net/grant110/blog/161332
    // http://justsee.iteye.com/blog/1774722
    
    if (self = [super init]) {
        self.interval = interval;
        self.target = target;
        self.selector = selector;
        self.userInfo = userInfo;
        self.repeats = repeats;
        self.serialQueue = dispatch_queue_create("com.xinglian.dispatchTimer", DISPATCH_QUEUE_SERIAL);
        self.dispatchTimer = dispatch_source_create(DISPATCH_SOURCE_TYPE_TIMER,
                                                     0,
                                                     0,
                                                     self.serialQueue);
    }
    
    return self;
}

+ (PGTimer *)scheduledTimerWithTimerInterval:(NSTimeInterval)interval
                                      target:(id)target
                                    selector:(SEL)selector
                                    userInfo:(id)userInfo
                                     repeats:(BOOL)repeats
{
    PGTimer *timer = [[self alloc] initWithTimerInterval:interval
                                                  target:target
                                                selector:selector
                                                userInfo:userInfo
                                                 repeats:repeats];
    if (timer.dispatchTimer) {
        [timer schedule];
    }
    
    return timer;
}

- (void)dealloc
{
    [self invalidate];
}

- (void)invalidate
{
    dispatch_source_t dispatchTimer = self.dispatchTimer;
    dispatch_async(self.serialQueue, ^{
        dispatch_source_cancel(dispatchTimer);
    });
}

- (void)fire
{
    [self schedule];
}

- (void)schedule
{
    int64_t intervalInNanoseconds = (int64_t)(self.interval * NSEC_PER_SEC);
    dispatch_source_set_timer(self.dispatchTimer,
                              0.f,
                              intervalInNanoseconds,
                              0.f);
    
    __weak typeof(self) weakSelf = self;
    dispatch_source_set_event_handler(self.dispatchTimer, ^{
        [weakSelf handleEvent];
    });
    
    dispatch_resume(self.dispatchTimer);
}

- (void)handleEvent
{
    [self.target performSelector:self.selector withObject:self];
    
    if (!self.repeats) {
        [self invalidate];
    }
}

@end
