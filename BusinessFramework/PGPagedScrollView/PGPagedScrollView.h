//
//  PGPagedScrollView.h
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FLAnimatedImage.h"

typedef NS_ENUM(NSInteger, PGPagedScrollViewImageFillMode) {
    PGPagedScrollViewImageFillModeFit,
    PGPagedScrollViewImageFillModeFill
};

@protocol PGPagedScrollViewDelegate <NSObject>

- (NSArray *)imagesForScrollView;

@end

@interface PGPagedScrollView : UIView

@property (nonatomic, weak) id<PGPagedScrollViewDelegate> delegate;

- (id)initWithFrame:(CGRect)frame imageFillMode:(PGPagedScrollViewImageFillMode)fillMode;

- (void)reloadData;

@end
