//
//  PGHistoryViewModel.h
//  Penguin
//
//  Created by Jing Dai on 31/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGHistory.h"

@interface PGHistoryViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *histories;

@end
