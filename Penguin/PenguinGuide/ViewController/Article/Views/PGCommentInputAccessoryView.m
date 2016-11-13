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
    self.backgroundColor = [UIColor whiteColor];
    
    [self addSubview:self.commentTextView];
    
    UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.pg_width, 1/[UIScreen mainScreen].scale)];
    horizontalLine.backgroundColor = Theme.colorLightBorder;
    [self addSubview:horizontalLine];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(textViewDidChange) name:UITextViewTextDidChangeNotification object:nil];
}

#pragma mark - <UITextViewDelegate>

- (void)textViewDidChange
{
    // NOTE: boundingRectWithSize doesn't work. use sizeThatFits instead.
    CGSize textSize = [self.commentTextView sizeThatFits:CGSizeMake(self.pg_width-54, MAXFLOAT)];
    
    if (textSize.height > 100) {
        self.commentTextView.scrollEnabled = YES;
        return;
    }
    
    if (self.commentTextView.pg_height != textSize.height) {
        
        self.frame = CGRectMake(0, self.pg_y+self.pg_height-(textSize.height+14), UISCREEN_WIDTH, textSize.height+14);
        self.commentTextView.frame = CGRectMake(27, (self.pg_height-textSize.height)/2, self.pg_width-54, textSize.height);
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
        _commentTextView = [[PGCommentTextView alloc] initWithFrame:CGRectMake(27, 7, self.pg_width-54, 30)];
        _commentTextView.textColor = Theme.colorText;
        _commentTextView.font = Theme.fontMedium;
        _commentTextView.backgroundColor = [UIColor whiteColor];
        _commentTextView.returnKeyType = UIReturnKeySend;
        _commentTextView.delegate = self;
        _commentTextView.placeholder = @"输 入 你 的 回 复";
        
        CGSize textSize = [_commentTextView sizeThatFits:CGSizeMake(self.pg_width-27, MAXFLOAT)];
        _commentTextView.frame = CGRectMake(27, (self.pg_height-textSize.height)/2, self.pg_width-54, textSize.height);
    }
    return _commentTextView;
}

@end
