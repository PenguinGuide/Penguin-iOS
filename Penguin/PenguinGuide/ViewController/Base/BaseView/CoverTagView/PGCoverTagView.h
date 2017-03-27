//
//  PGCoverTagView.h
//  Penguin
//
//  Created by Kobe Dai on 27/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

typedef NS_ENUM(NSInteger, PGCoverTagViewStyle) {
    PGCoverTagViewStyleNormal,
    PGCoverTagViewStyleHot,
    PGCoverTagViewStyleNew
};

typedef NS_ENUM(NSInteger, PGCoverTagViewAlignment) {
    PGCoverTagViewAlignmentLeft,
    PGCoverTagViewAlignmentRight
};

#import <UIKit/UIKit.h>

@interface PGCoverTagView : UIView

+ (PGCoverTagView *)tagViewWithMargin:(CGPoint)margin alignment:(PGCoverTagViewAlignment)alignment;

- (void)setTagViewWithTitle:(NSString *)title style:(PGCoverTagViewStyle)style;

@end
