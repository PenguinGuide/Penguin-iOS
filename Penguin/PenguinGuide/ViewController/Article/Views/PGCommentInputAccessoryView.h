//
//  PGCommentInputView.h
//  Penguin
//
//  Created by Jing Dai on 22/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGCommentTextView.h"

@protocol PGCommentInputAccessoryViewDelegate <NSObject>

- (void)sendComment:(NSString *)comment;

@end

@interface PGCommentInputAccessoryView : UIView

@property (nonatomic, weak) id<PGCommentInputAccessoryViewDelegate> delegate;

@property (nonatomic, strong) PGCommentTextView *commentTextView;

@end
