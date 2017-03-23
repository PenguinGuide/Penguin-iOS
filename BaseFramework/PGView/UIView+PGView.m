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
static char PGLongPresseGestureKey;
static char PGLongPresseHandlerKey;

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

- (void)setLongPressedAction:(void (^)(void))completion
{
    UILongPressGestureRecognizer *longPressGesture = objc_getAssociatedObject(self, &PGLongPresseGestureKey);
    if (!longPressGesture) {
        longPressGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressRecognized:)];
        [self addGestureRecognizer:longPressGesture];
        objc_setAssociatedObject(self, &PGLongPresseGestureKey, longPressGesture, OBJC_ASSOCIATION_RETAIN);
    }
    objc_setAssociatedObject(self, &PGLongPresseHandlerKey, completion, OBJC_ASSOCIATION_COPY);
}

- (void)longPressRecognized:(UIGestureRecognizer *)recognizer
{
    if (recognizer.state == UIGestureRecognizerStateRecognized) {
        void(^action)(void) = objc_getAssociatedObject(self, &PGLongPresseHandlerKey);
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

- (void)cropCornerRadius:(CGFloat)cornerRadius
{
    CAShapeLayer *maskLayer = [CAShapeLayer layer];
    maskLayer.frame = CGRectMake(0, 0, self.pg_width, self.pg_height);
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.pg_width, self.pg_height) cornerRadius:cornerRadius];
    maskLayer.path = bezierPath.CGPath;
    
    [self.layer setMask:maskLayer];
}

- (void)addBorder:(UIColor *)color borderWidth:(CGFloat)borderWidth cornerRadius:(CGFloat)cornerRadius
{
    CAShapeLayer *maskLayer;
    if (cornerRadius > 0.f) {
        maskLayer = [CAShapeLayer layer];
        maskLayer.frame = CGRectMake(0, 0, self.pg_width, self.pg_height);
    }
    
    CAShapeLayer *borderLayer = [CAShapeLayer layer];
    borderLayer.frame = CGRectMake(0, 0, self.pg_width, self.pg_height);
    borderLayer.lineWidth = borderWidth;
    borderLayer.strokeColor = color.CGColor;
    borderLayer.fillColor = [UIColor clearColor].CGColor;
    
    UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, self.pg_width, self.pg_height) cornerRadius:cornerRadius];
    if (maskLayer) {
        maskLayer.path = bezierPath.CGPath;
    }
    borderLayer.path = bezierPath.CGPath;
    
    [self.layer insertSublayer:borderLayer atIndex:0];
    if (maskLayer) {
        [self.layer setMask:maskLayer];
    }
}

@end
