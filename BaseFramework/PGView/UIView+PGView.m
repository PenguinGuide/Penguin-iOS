//
//  UIView+PGView.m
//  Penguin
//
//  Created by Jing Dai on 6/30/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "UIView+PGView.h"
#import <objc/runtime.h>

static char PGTapGestureKey;
static char PGTapHandlerKey;

@interface UIView ()

@end

@implementation UIView (PGView)

- (float)x
{
    return self.frame.origin.x;
}

- (float)y
{
    return self.frame.origin.y;
}

- (float)width
{
    return CGRectGetWidth(self.frame);
}

- (float)height
{
    return CGRectGetHeight(self.frame);
}

- (float)left
{
    return self.frame.origin.x;
}

- (float)right
{
    return self.frame.origin.x+self.frame.size.width;
}

- (float)top
{
    return self.frame.origin.y;
}

- (float)bottom
{
    return self.frame.origin.y+self.frame.size.height;
}

- (void)setX:(float)x
{
    CGRect frame = self.frame;
    CGRect newFrame = CGRectMake(x, frame.origin.y, frame.size.width, frame.size.height);
    
    self.frame = newFrame;
}

- (void)setY:(float)y
{
    CGRect frame = self.frame;
    CGRect newFrame = CGRectMake(frame.origin.x, y, frame.size.width, frame.size.height);
    
    self.frame = newFrame;
}

- (void)setWidth:(float)width
{
    CGRect frame = self.frame;
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, width, frame.size.height);
    
    self.frame = newFrame;
}

- (void)setHeight:(float)height
{
    CGRect frame = self.frame;
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, height);
    
    self.frame = newFrame;
}

- (void)setTapAction:(void (^)(void))completion
{
    UITapGestureRecognizer *tapGesture = objc_getAssociatedObject(self, &PGTapGestureKey);
    if (!tapGesture) {
        tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapRecognized:)];
        [self addGestureRecognizer:tapGesture];
        objc_setAssociatedObject(self, &PGTapGestureKey, tapGesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &PGTapHandlerKey, completion, OBJC_ASSOCIATION_COPY);
}

- (void)tapRecognized:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &PGTapHandlerKey);
        if (action) {
            action();
        }
    }
}

@end
