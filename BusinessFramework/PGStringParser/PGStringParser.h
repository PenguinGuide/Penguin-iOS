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
#import "PGParserCatalogImageStorage.h"
#import "PGParserVideoStorage.h"
#import "PGParserSingleGoodStorage.h"
#import "PGParserGoodsCollectionStorage.h"

@interface PGStringParser : NSObject

+ (instancetype)htmlParserWithString:(NSString *)htmlString;

- (NSArray *)articleParsedStorages;

@end
