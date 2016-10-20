//
//  NSValueTransformer+PGRKValueTransformer.m
//  Penguin
//
//  Created by Jing Dai on 8/24/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "NSValueTransformer+PGRKValueTransformer.h"
#import <Mantle/Mantle.h>

NSString *const PGStringValueTransformer = @"PGStringValueTransformer";
NSString *const PGCommentTimeValueTransformer = @"PGCommentTimeValueTransformer";

static NSDateFormatter *commentTimeDateFormatter = nil;
static NSDateFormatter *commentTimeHourFormatter = nil;

@implementation NSValueTransformer (PGRKValueTransformer)

+ (void)load
{
    @autoreleasepool {
        // string value transformer
        MTLValueTransformer *stringValueTransformer = [MTLValueTransformer transformerUsingReversibleBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            if (value == nil) return nil;
            
            if ([value isKindOfClass:[NSNumber class]]) {
                NSString *stringValue = [NSString stringWithFormat:@"%@", value];
                return stringValue;
            } else if ([value isKindOfClass:[NSString class]]) {
                return value;
            } else{
                return nil;
            }
        }];
        [NSValueTransformer setValueTransformer:stringValueTransformer forName:PGStringValueTransformer];
        
        // comment time value transformer
        MTLValueTransformer *commentTimeValueTransformer = [MTLValueTransformer transformerUsingForwardBlock:^id(id value, BOOL *success, NSError *__autoreleasing *error) {
            if (value == nil) return nil;
            // NOTE: calculate NSTimeInterval http://blog.csdn.net/u010971348/article/details/51066551
            if ([value isKindOfClass:[NSNumber class]]) {
                NSTimeInterval timeInterval = [value doubleValue];
                NSDate *date = [NSDate dateWithTimeIntervalSince1970:timeInterval];
                NSTimeInterval timeDiff = [[NSDate date] timeIntervalSinceDate:date];
                if (timeDiff <= 60) {
                    return @"刚刚";
                }
                if (timeDiff <= 60*60) {
                    int mins = timeDiff/60;
                    return [NSString stringWithFormat:@"%d分钟前", mins];
                }
                if (timeDiff <= 60*60*24) {
                    return [[self commentTimeHourFormatter] stringFromDate:date];
                }
                if (timeDiff <= 60*60*24*2) {
                    return @"昨天";
                }
                if (timeDiff <= 60*60*24*3) {
                    return @"两天前";
                }
                if (timeDiff <= 60*60*24*4) {
                    return @"三天前";
                }
                if (timeDiff <= 60*60*24*5) {
                    return @"四天前";
                }
                if (timeDiff <= 60*60*24*6) {
                    return @"五天前";
                }
                return [[self commentTimeDateFormatter] stringFromDate:date];
            } else {
                return nil;
            }
        }];
        [NSValueTransformer setValueTransformer:commentTimeValueTransformer forName:PGCommentTimeValueTransformer];
    }
}

+ (NSDateFormatter *)commentTimeDateFormatter
{
    if (!commentTimeDateFormatter) {
        commentTimeDateFormatter = [[NSDateFormatter alloc] init];
        commentTimeDateFormatter.timeZone = [NSTimeZone timeZoneWithAbbreviation:@"GMT+0800"];
        commentTimeDateFormatter.locale = [NSLocale currentLocale];
        [commentTimeDateFormatter setDateFormat:@"yyyy.M.dd"];
    }
    return commentTimeDateFormatter;
}

+ (NSDateFormatter *)commentTimeHourFormatter
{
    if (!commentTimeHourFormatter) {
        commentTimeHourFormatter = [[NSDateFormatter alloc] init];
        commentTimeHourFormatter.timeZone = [NSTimeZone timeZoneWithName:@"GMT+0800"];
        commentTimeHourFormatter.locale = [NSLocale currentLocale];
        [commentTimeHourFormatter setDateFormat:@"HH:mm"];
    }
    return commentTimeHourFormatter;
}

@end
