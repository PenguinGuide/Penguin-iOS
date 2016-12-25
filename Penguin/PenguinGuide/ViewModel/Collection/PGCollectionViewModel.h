//
//  PGCollectionViewModel.h
//  Penguin
//
//  Created by Jing Dai on 30/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGCollection.h"

@interface PGCollectionViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *collections;

@end
