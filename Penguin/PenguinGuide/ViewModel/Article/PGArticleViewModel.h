//
//  PGArticleViewModel.h
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGArticle.h"
#import "PGComment.h"

@interface PGArticleViewModel : PGBaseViewModel

@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) PGArticle *article;
@property (nonatomic, strong) NSArray *commentsArray;
@property (nonatomic, strong) NSArray *paragraphsArray;
@property (nonatomic, strong, readonly) NSError *commentError;

@property (nonatomic, assign) BOOL likeSuccess;
@property (nonatomic, assign) BOOL dislikeSuccess;
@property (nonatomic, assign) BOOL collectSuccess;
@property (nonatomic, assign) BOOL discollectSuccess;

- (void)requestGoods:(void(^)())completion;

- (void)likeArticle;
- (void)dislikeArticle;
- (void)collectArticle;
- (void)discollectArticle;

- (void)requestComments;
- (void)sendComment:(NSString *)content completion:(void(^)(BOOL success))completion;
- (void)sendReplyComment:(NSString *)content commentId:(NSString *)commentId completion:(void(^)(BOOL success))completion;
- (void)likeComment:(NSString *)commentId completion:(void(^)(BOOL success))completion;
- (void)dislikeComment:(NSString *)commentId completion:(void(^)(BOOL success))completion;
- (void)reportComment:(NSString *)commentId completion:(void(^)(BOOL success))completion;

@end
