//
//  PGLog.h
//  Penguin
//
//  Created by Jing Dai on 6/28/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CocoaLumberjack/CocoaLumberjack.h>
#import "DDLog.h"

/**
 Log Level Aliases
 */
#define PGLogLevelOff       DDLogLevelOff
#define PGLogLevelError     DDLogLevelError
#define PGLogLevelWarning   DDLogLevelWarning
#define PGLogLevelInfo      DDLogLevelInfo
#define PGLogLevelDebug     DDLogLevelDebug
#define PGLogLevelTrace     DDLogLevelVerbose

/**
 Log Aliases
 */
#define PGLogError(frmt, ...)                                                                                                             \
LOG_MAYBE(NO,                DDLogLevelError, DDLogFlagError,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define PGLogWarning(frmt, ...)                                                                                                           \
LOG_MAYBE(LOG_ASYNC_ENABLED, DDLogLevelWarning, DDLogFlagWarning, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define PGLogInfo(frmt, ...)                                                                                                              \
LOG_MAYBE(LOG_ASYNC_ENABLED, DDLogLevelInfo, DDLogFlagInfo,    0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define PGLogDebug(frmt, ...)                                                                                                             \
LOG_MAYBE(LOG_ASYNC_ENABLED, XYLogLevelDebug, DDLogFlagDebug,   0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

#define PGLogTrace(frmt, ...)                                                                                                             \
LOG_MAYBE(LOG_ASYNC_ENABLED, XYLogLevelTrace, DDLogFlagVerbose, 0, nil, __PRETTY_FUNCTION__, frmt, ##__VA_ARGS__)

@interface PGLog : NSObject

/**
 *  Turn on logging
 */
+ (void)setup;

/**
 *  Turn off logging
 */
+ (void)turnOffLogging;

@end
