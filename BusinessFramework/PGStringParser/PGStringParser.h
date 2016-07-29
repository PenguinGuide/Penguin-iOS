//
//  PGStringParser.h
//  Penguin
//
//  Created by Jing Dai on 7/25/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGParserTextStorage.h"
#import "PGParserImageStorage.h"

@interface PGStringParser : NSObject

+ (instancetype)htmlParserWithString:(NSString *)htmlString;

- (NSArray *)articleParsedStorages;

@end
