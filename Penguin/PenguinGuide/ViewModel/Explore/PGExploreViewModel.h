//
//  PGExploreViewModel.h
//  Penguin
//
//  Created by Jing Dai on 8/29/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"

@interface PGExploreViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *recommendsArray;
@property (nonatomic, strong, readonly) NSArray *scenariosArray;
@property (nonatomic, strong, readonly) NSArray *bannersArray;

@end
