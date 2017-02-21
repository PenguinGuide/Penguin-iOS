//
//  UIView+PGAnalytics.m
//  Penguin
//
//  Created by Kobe Dai on 24/01/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

static char EventName;

static char EventId;
static char PageName;
static char PageId;
static char ExtraParams;

#import "UIView+PGAnalytics.h"
#import "PGAnalytics.h"
#import <objc/runtime.h>

@implementation UIView (PGAnalytics)

+ (void)setupHook
{
    // http://www.cnblogs.com/wengzilin/p/4704996.html?utm_source=tuicool
    [UIButton aspect_hookSelector:@selector(sendAction:to:forEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info) {
        id instance = [info instance];
        [PGAnalytics trackEvent:[self eventName:instance] params:[self eventParams:instance]];
    } error:NULL];
    
    [UICollectionView aspect_hookSelector:@selector(touchesEnded:withEvent:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> info, NSSet *touches, UIEvent *event) {
        id instance = [info instance];
        [PGAnalytics trackEvent:[self eventName:instance] params:[self eventParams:instance]];
    } error:NULL];
}

+ (NSString *)eventName:(id)instance
{
    if ([instance isKindOfClass:[UIButton class]] && [instance respondsToSelector:@selector(eventName)]) {
        NSString *eventName = [instance eventName];
        return eventName;
    } else if ([instance isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)instance;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:collectionView.indexPathsForSelectedItems.firstObject];
        if (cell && [cell respondsToSelector:@selector(eventName)]) {
            NSString *eventName = [cell eventName];
            return eventName;
        }
    }
    return nil;
}

+ (NSDictionary *)eventParams:(id)instance
{
    NSMutableDictionary *eventParams = [NSMutableDictionary new];
    NSString *eventId;
    NSString *pageName;
    NSString *pageId;
    NSDictionary *extraParams;
    
    if ([instance isKindOfClass:[UIButton class]]) {
        UIButton *button = (UIButton *)instance;
        if ([button respondsToSelector:@selector(eventId)]) {
            eventId = [button eventId];
        }
    } else if ([instance isKindOfClass:[UICollectionView class]]) {
        UICollectionView *collectionView = (UICollectionView *)instance;
        UICollectionViewCell *cell = [collectionView cellForItemAtIndexPath:collectionView.indexPathsForSelectedItems.firstObject];
        if (cell) {
            if ([cell respondsToSelector:@selector(eventId)]) {
                eventId = [cell eventId];
            }
            if ([cell respondsToSelector:@selector(pageName)]) {
                pageName = [cell pageName];
            }
            if ([cell respondsToSelector:@selector(pageId)]) {
                pageId = [cell pageId];
            }
            if ([cell respondsToSelector:@selector(extraParams)]) {
                extraParams = [cell extraParams];
            }
        }
    }
    
    if (eventId && eventId.length > 0) {
        eventParams[event_id] = eventId;
    }
    if (pageName && pageName.length > 0) {
        eventParams[page_name] = pageName;
    }
    if (pageId && pageId.length > 0) {
        eventParams[page_id] = pageId;
    }
    if (extraParams && extraParams.count > 0) {
        [eventParams addEntriesFromDictionary:extraParams];
    }
    
    return [NSDictionary dictionaryWithDictionary:eventParams];
}

- (void)setEventName:(NSString *)eventName
{
    objc_setAssociatedObject(self, &EventName, eventName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)eventName
{
    return objc_getAssociatedObject(self, &EventName);
}

- (void)setEventId:(NSString *)eventId
{
    objc_setAssociatedObject(self, &EventId, eventId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)eventId
{
    return objc_getAssociatedObject(self, &EventId);
}

- (void)setPageName:(NSString *)pageName
{
    objc_setAssociatedObject(self, &PageName, pageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)pageName
{
    return objc_getAssociatedObject(self, &PageName);
}

- (void)setPageId:(NSString *)pageId
{
    objc_setAssociatedObject(self, &PageId, pageId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)pageId
{
    return objc_getAssociatedObject(self, &PageId);
}

- (void)setExtraParams:(NSDictionary *)extraParams
{
    objc_setAssociatedObject(self, &ExtraParams, extraParams, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSDictionary *)extraParams
{
    return objc_getAssociatedObject(self, &ExtraParams);
}

@end
