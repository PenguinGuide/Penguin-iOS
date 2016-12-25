//
//  PGRouter.m
//  Penguin
//
//  Created by Jing Dai on 6/28/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGRouter.h"

@interface PGRouter ()

/**
*   qiechihe://user/notes?noteId=11111 -> @{@"user":@{@"notes":@{@"_":[block copy]}}} -> @{@"qiechihe":@{@"user":@{@"notes":@{@"_":[block copy]}}}}
*/
@property (nonatomic, strong) NSMutableDictionary *routes;

@end

@implementation PGRouter

+ (PGRouter *)sharedInstance
{
    static PGRouter *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[PGRouter alloc] init];
    });
    
    return sharedInstance;
}

- (void)registerRoute:(NSString *)route toHandler:(PGRouterHandler)handler
{
    if (handler) {
        [self handleRoute:route handler:handler];
    }
}

- (void)openURL:(NSString *)route
{
    route = [route stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    // extract url parameters
    NSMutableDictionary *params = [self extractParametersFromRoute:route];
    
    // path components
    NSArray *pathComponents = [self pathComponents:route];
    
    NSString *scheme = pathComponents[0];
    if ([scheme isEqualToString:@"http"] || [scheme isEqualToString:@"https"]) {
        // http && https
        if (route && route.length > 0) {
            NSMutableDictionary *parameters = [NSMutableDictionary new];
            parameters[@"web_url"] = route;
            
            if (self.routes[scheme]) {
                NSMutableDictionary *pathSubDict = self.routes[scheme];
                
                if ([pathSubDict objectForKey:@"_"]) {
                    PGRouterHandler handler = pathSubDict[@"_"];
                    if (handler) {
                        handler(parameters);
                    }
                }
            }
        }
    } else {
        [self openURL:pathComponents parameters:params];
    }
}

#pragma mark - <Private Methods>

- (void)handleRoute:(NSString *)route handler:(PGRouterHandler)handler
{
    NSArray *pathComponents = [self pathComponents:route];
    
    if (pathComponents.count >= 2) {
        NSString *scheme = pathComponents[0];
        if (![self.routes objectForKey:scheme]) {
            self.routes[scheme] = [NSMutableDictionary dictionary];
        }
        
        NSMutableDictionary *pathSubDict = self.routes[scheme];
        for (int i = 1; i < pathComponents.count; i++) {
            if (![pathSubDict objectForKey:pathComponents[i]]) {
                pathSubDict[pathComponents[i]] = [NSMutableDictionary dictionary];
            }
            pathSubDict = pathSubDict[pathComponents[i]];
        }
        
        pathSubDict[@"_"] = [handler copy];
    } else {
        if (pathComponents.count == 1 && ([pathComponents[0] isEqualToString:@"http"] || [pathComponents[0] isEqualToString:@"https"])) {
            // http && https
            NSString *scheme = pathComponents[0];
            if (![self.routes objectForKey:scheme]) {
                self.routes[scheme] = [NSMutableDictionary dictionary];
            }
            
            NSMutableDictionary *pathSubDict = self.routes[scheme];
            pathSubDict[@"_"] = [handler copy];
        }
    }
}

- (NSArray *)pathComponents:(NSString *)route
{
    NSMutableArray *pathComponents = [NSMutableArray new];
    
    if ([route containsString:@"://"]) {
        NSArray *components = [route componentsSeparatedByString:@"://"];
        if (components.count >= 2) {
            NSString *scheme = components[0];
            NSString *urlStr = components[1];
            
            [pathComponents addObject:scheme];
            
            NSURL *URL = [NSURL URLWithString:urlStr];
            for (NSString *pathComponent in URL.pathComponents) {
                if ([pathComponent isEqualToString:@"/"]) continue;
                if ([[pathComponent substringToIndex:1] isEqualToString:@"?"]) break;
                
                [pathComponents addObject:pathComponent];
            }
        }
    }
    
    return [pathComponents copy];
}

- (NSMutableDictionary *)extractParametersFromRoute:(NSString *)route
{
    NSMutableDictionary *params = [NSMutableDictionary new];
    
    NSArray *components = [route componentsSeparatedByString:@"?"];
    if (components.count >= 2) {
        NSString *paramsStr = components[1];
        NSArray *paramsArray = [paramsStr componentsSeparatedByString:@"&"];
        for (NSString *paramStr in paramsArray) {
            NSArray *paramArray = [paramStr componentsSeparatedByString:@"="];
            if (paramArray.count >= 2) {
                NSString *key = paramArray[0];
                NSString *value = paramArray[1];
                params[key] = value;
            }
        }
    }
    
    return params;
}

- (void)openURL:(NSArray *)pathComponents parameters:(NSMutableDictionary *)parameters
{
    BOOL routeFound = YES;
    NSMutableDictionary *pathSubDict = nil;
    for (int i = 0; i < pathComponents.count; i++) {
        NSString *pathComponent = pathComponents[i];
        // scheme
        if (i == 0) {
            if ([self.routes objectForKey:pathComponent]) {
                pathSubDict = self.routes[pathComponent];
            } else {
                routeFound = NO;
                break;
            }
        } else {
            if ([pathSubDict objectForKey:pathComponent]) {
                pathSubDict = pathSubDict[pathComponent];
            } else {
                routeFound = NO;
                break;
            }
        }
    }
    
    if (routeFound) {
        if ([pathSubDict objectForKey:@"_"]) {
            PGRouterHandler handler = pathSubDict[@"_"];
            if (handler) {
                handler(parameters);
            }
        } else {
            NSLog(@"block not found");
        }
    } else {
        NSLog(@"route not found");
    }
}

#pragma mark - <Setters && Getters>

- (NSMutableDictionary *)routes
{
    if (!_routes) {
        _routes = [NSMutableDictionary new];
    }
    
    return _routes;
}

@end
