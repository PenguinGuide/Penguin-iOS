//
//  PGMessageViewModel.h
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGMessage.h"

@interface PGMessageViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *messages;

- (void)requestSystemMessages;
- (void)requestReplyMessages;

@end
