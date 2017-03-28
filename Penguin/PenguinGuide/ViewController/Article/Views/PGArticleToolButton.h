//
//  PGArticleToolButton.h
//  Penguin
//
//  Created by Kobe Dai on 24/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGArticleToolButton : UIButton

+ (PGArticleToolButton *)toolButtonWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)image highlightedImage:(UIImage *)highlightedImage imageSize:(CGSize)imageSize count:(NSInteger)count;

- (void)updateCount:(NSInteger)count;

@end
