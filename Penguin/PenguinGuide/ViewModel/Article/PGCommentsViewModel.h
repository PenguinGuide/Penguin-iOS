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

- (void)requestComments:(NSString *)articleId;
- (void)sendComment:(NSString *)content completion:(void(^)(BOOL success))completion;
- (void)sendReplyComment:(NSString *)content commentId:(NSString *)commentId completion:(void(^)(BOOL success))completion;
- (void)likeComment:(NSString *)commentId completion:(void(^)(BOOL success))completion;
- (void)dislikeComment:(NSString *)commentId completion:(void(^)(BOOL success))completion;
- (void)deleteComment:(NSString *)commentId completion:(void(^)(BOOL success))completion;

@end
