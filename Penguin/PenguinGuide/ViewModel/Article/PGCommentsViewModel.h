//
//  PGCommentsViewModel.h
//  Penguin
//
//  Created by Jing Dai on 11/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGComment.h"

@interface PGCommentsViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *commentsArray;

@end
