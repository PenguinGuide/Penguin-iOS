//
//  PGMeViewModel.h
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGMe.h"

@interface PGMeViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) PGMe *me;
@property (nonatomic, assign, readonly) BOOL readSuccess;

- (void)requestDetails;
- (void)readMessages;

@end
