//
//  PGCopyLabel.m
//  Penguin
//
//  Created by Kobe Dai on 12/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGCopyLabel.h"

@implementation PGCopyLabel

- (instancetype)initWithFrame:(CGRect)frame
{
    // NOTE: UILabel can be copied: http://www.jianshu.com/p/b0eb1e88a928
    self = [super initWithFrame:frame];
    if (self) {
        PGWeakSelf(self);
        self.userInteractionEnabled = YES;
        [self setLongPressedAction:^{
            [weakself becomeFirstResponder];
            UIMenuItem *copyItem = [[UIMenuItem alloc] initWithTitle:@"拷贝" action:@selector(customCopy:)];
            [[UIMenuController sharedMenuController] setMenuItems:[NSArray arrayWithObjects:copyItem, nil]];
            [[UIMenuController sharedMenuController] setTargetRect:weakself.frame inView:weakself.superview];
            [[UIMenuController sharedMenuController] setMenuVisible:YES animated:YES];
        }];
    }
    return self;
}

- (BOOL)canBecomeFirstResponder {
    return YES;
}

// 控制响应的方法
- (BOOL)canPerformAction:(SEL)action withSender:(id)sender {
    return action == @selector(customCopy:);
}

- (void)customCopy:(id)sender
{
    UIPasteboard *pasteboard = [UIPasteboard generalPasteboard];
    pasteboard.string = self.text;
}

@end
