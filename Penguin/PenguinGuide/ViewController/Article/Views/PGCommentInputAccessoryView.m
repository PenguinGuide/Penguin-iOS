//
//  PGCommentInputView.m
//  Penguin
//
//  Created by Jing Dai on 22/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGCommentInputAccessoryView.h"

@interface PGCommentInputAccessoryView () <UITextViewDelegate>

@end

@implementation PGCommentInputAccessoryView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    self.backgroundColor = Theme.colorLightBackground;
    
    [self addSubview:self.commentTextView];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - <UITextViewDelegate>

- (void)textViewDidChange
{
    // NOTE: boundingRectWithSize doesn't work. use sizeThatFits instead.
    CGSize textSize = [self.commentTextView sizeThatFits:CGSizeMake(self.width-30, MAXFLOAT)];
    
    if (textSize.height > 100) {
        self.commentTextView.scrollEnabled = YES;
        return;
    }
    
    if (self.commentTextView.height != textSize.height) {
        
        self.frame = CGRectMake(0, self.y+self.height-(textSize.height+14), UISCREEN_WIDTH, textSize.height+14);
        self.commentTextView.frame = CGRectMake(15, (self.height-textSize.height)/2, self.width-30, textSize.height);
    }
    
    NSLog(@"%@", NSStringFromCGSize(textSize));
}

// NOTE: fix UITextView does not have any methods which will be called when the user hits the return key http://stackoverflow.com/questions/703754/how-to-dismiss-keyboard-for-uitextview-with-return-key
- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
{
    if ([text isEqualToString:@"\n"]) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(sendComment:)]) {
            [self.delegate sendComment:textView.text];
        }
        return NO;
    }
    return YES;
}

- (UITextView *)commentTextView
{
    if (!_commentTextView) {
        _commentTextView = [[PGCommentTextView alloc] initWithFrame:CGRectMake(15, 7, self.width-30, 30)];
        _commentTextView.textColor = Theme.colorText;
        _commentTextView.font = Theme.fontSmall;
        _commentTextView.backgroundColor = Theme.colorLightBackground;
        _commentTextView.returnKeyType = UIReturnKeySend;
        _commentTextView.delegate = self;
        _commentTextView.placeholder = @"输 入 你 的 回 复";
        
        CGSize textSize = [_commentTextView sizeThatFits:CGSizeMake(self.width-30, MAXFLOAT)];
        _commentTextView.frame = CGRectMake(15, (self.height-textSize.height)/2, self.width-30, textSize.height);
    }
    return _commentTextView;
}

@end
