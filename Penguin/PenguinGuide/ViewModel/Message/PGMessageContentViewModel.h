//
//  PGMessageContentViewModel.h
//  Penguin
//
//  Created by Kobe Dai on 26/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGMessage.h"

@interface PGMessageContentViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *messages;

- (void)requestSystemMessages;
- (void)requestReplyMessages;
- (void)requestLikesMessages;

- (void)sendReplyComment:(NSString *)content commentId:(NSString *)commentId completion:(void(^)(BOOL success))completion;

@end
