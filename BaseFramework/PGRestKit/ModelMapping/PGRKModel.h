//
//  PGRKModel.h
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Mantle/Mantle.h>

@interface PGRKModel : MTLModel

/**
 *  Response object mapping for this class
 *
 *  @return an NSDictionary object for this class
 */
+ (NSDictionary *)JSONKeyPathsByPropertyKey;

/**
 * Manual mapping for this class from dict
 *
 * @return model object of this class
 */
+ (PGRKModel *)modelFromDictionary:(NSDictionary *)dict;

/**
 * Manual mapping for this class from array
 *
 * @return array of model objects of this class
 */
+ (NSArray *)modelsFromArray:(NSArray *)array;

@end
