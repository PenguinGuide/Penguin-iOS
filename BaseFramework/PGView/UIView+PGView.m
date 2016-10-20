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

- (CGFloat)pg_x
{
    return self.frame.origin.x;
}

- (CGFloat)pg_y
{
    return self.frame.origin.y;
}

- (CGFloat)pg_width
{
    return CGRectGetWidth(self.frame);
}

- (CGFloat)pg_height
{
    return CGRectGetHeight(self.frame);
}

- (CGFloat)pg_left
{
    return self.frame.origin.x;
}

- (CGFloat)pg_right
{
    return self.frame.origin.x+self.frame.size.width;
}

- (CGFloat)pg_top
{
    return self.frame.origin.y;
}

- (CGFloat)pg_bottom
{
    return self.frame.origin.y+self.frame.size.height;
}

- (void)setPg_x:(CGFloat)pg_x
{
    CGRect frame = self.frame;
    CGRect newFrame = CGRectMake(pg_x, frame.origin.y, frame.size.width, frame.size.height);
    
    self.frame = newFrame;
}

- (void)setPg_y:(CGFloat)pg_y
{
    CGRect frame = self.frame;
    CGRect newFrame = CGRectMake(frame.origin.x, pg_y, frame.size.width, frame.size.height);
    
    self.frame = newFrame;
}

- (void)setPg_width:(CGFloat)pg_width
{
    CGRect frame = self.frame;
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, pg_width, frame.size.height);
    
    self.frame = newFrame;
}

- (void)setPg_height:(CGFloat)pg_height
{
    CGRect frame = self.frame;
    CGRect newFrame = CGRectMake(frame.origin.x, frame.origin.y, frame.size.width, pg_height);
    
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

- (UIImage *)screenshot
{
    UIGraphicsBeginImageContextWithOptions(self.bounds.size, YES, 0);
    
    [self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return screenshot;
}

- (UIImage *)screenshotFromRect:(CGRect)rect
{
    UIGraphicsBeginImageContext(self.bounds.size);
    
    // wrong screenshot, self.bounds.y will be the offsetY of collection view
    //[self drawViewHierarchyInRect:self.bounds afterScreenUpdates:YES];
    [self drawViewHierarchyInRect:CGRectMake(self.bounds.origin.x, 0, self.bounds.size.width, self.bounds.size.height) afterScreenUpdates:YES];
    UIImage *screenshot = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    CGImageRef imageRef = [screenshot CGImage];
    screenshot = [UIImage imageWithCGImage:CGImageCreateWithImageInRect(imageRef, rect)];
    
    CGImageRelease(imageRef);
    
    return screenshot;
}

@end
