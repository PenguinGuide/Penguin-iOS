//
//  PGLog.m
//  Penguin
//
//  Created by Jing Dai on 6/28/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLog.h"

@implementation PGLog

+ (void)setup
{
    setenv("XcodeColors", "YES", 0);
    
    [DDLog addLogger:[DDTTYLogger sharedInstance]];
    [[DDTTYLogger sharedInstance] setColorsEnabled:YES];
    
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:255 green:0 blue:0 alpha:1.f] backgroundColor:nil forFlag:DDLogFlagError];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:255 green:255 blue:0 alpha:1.f] backgroundColor:nil forFlag:DDLogFlagWarning];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:166 green:226 blue:46 alpha:1.f] backgroundColor:nil forFlag:DDLogFlagInfo];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:102 green:217 blue:239 alpha:1.f] backgroundColor:nil forFlag:DDLogFlagDebug];
    [[DDTTYLogger sharedInstance] setForegroundColor:[UIColor colorWithRed:117 green:113 blue:94 alpha:1.f] backgroundColor:nil forFlag:DDLogFlagVerbose];
}

+ (void)turnOffLogging
{
    [DDLog removeAllLoggers];
}

@end
