//
//  PGPageBasePlaceholder.h
//  Penguin
//
//  Created by Kobe Dai on 22/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGPageBasePlaceholderDelegate <NSObject>

@optional

- (void)reloadButtonClicked;

@end

@interface PGPageBasePlaceholder : UIView

@property (nonatomic, weak) id<PGPageBasePlaceholderDelegate> delegate;

- (id)initWithImage:(NSString *)image desc:(NSString *)desc top:(CGFloat)top height:(CGFloat)height;
- (id)initWithImage:(NSString *)image desc:(NSString *)desc buttonTitle:(NSString *)title top:(CGFloat)top height:(CGFloat)height;

@end
