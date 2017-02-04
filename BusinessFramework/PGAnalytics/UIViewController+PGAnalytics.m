//
//  UIViewController+PGAnalytics.m
//  Penguin
//
//  Created by Jing Dai on 8/4/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static char PageName;
static char PageTitle;
static char PageId;

#import "UIViewController+PGAnalytics.h"
#import "PGAnalytics.h"
#import <objc/runtime.h>

@implementation UIViewController (PGAnalytics)

+ (void)setupHook
{
    [UIViewController aspect_hookSelector:@selector(viewWillAppear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSString *pageName = [self pageName:[aspectInfo instance]];
        NSDictionary *pageParams = [self pageParams:[aspectInfo instance]];
        
        [PGAnalytics startPageView:pageName];
        [PGAnalytics trackEvent:pageName params:pageParams];
    } error:NULL];
    
    [UIViewController aspect_hookSelector:@selector(viewWillDisappear:) withOptions:AspectPositionAfter usingBlock:^(id<AspectInfo> aspectInfo, BOOL animated) {
        NSString *pageName = [self pageName:[aspectInfo instance]];
        [PGAnalytics endPageView:pageName];
    } error:NULL];
}

+ (NSString *)pageName:(id)instance
{
    if ([instance isKindOfClass:[UIViewController class]] && [instance respondsToSelector:@selector(pageName)]) {
        NSString *pageName = [instance pageName];
        return pageName;
    }
    return nil;
}

+ (NSDictionary *)pageParams:(id)instance
{
    NSString *pageTitle;
    NSString *pageId;
    
    if ([instance isKindOfClass:[UIViewController class]] && [instance respondsToSelector:@selector(pageTitle)]) {
        pageTitle = [instance pageTitle];
    }
    if ([instance isKindOfClass:[UIViewController class]] && [instance respondsToSelector:@selector(pageId)]) {
        pageId = [instance pageId];
    }
    
    NSMutableDictionary *params = [NSMutableDictionary new];
    if (pageTitle && pageTitle.length > 0) {
        params[page_title] = pageTitle;
    }
    if (pageId && pageId.length > 0) {
        params[page_id] = pageId;
    }
    
    return [NSDictionary dictionaryWithDictionary:params];
}

- (void)setPageName:(NSString *)pageName
{
    objc_setAssociatedObject(self, &PageName, pageName, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)pageName
{
    return objc_getAssociatedObject(self, &PageName);
}

- (void)setPageTitle:(NSString *)pageTitle
{
    objc_setAssociatedObject(self, &PageTitle, pageTitle, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)pageTitle
{
    return objc_getAssociatedObject(self, &PageTitle);
}

- (void)setPageId:(NSString *)pageId
{
    objc_setAssociatedObject(self, &PageId, pageId, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (NSString *)pageId
{
    return objc_getAssociatedObject(self, &PageId);
}

@end
