//
//  PGChannelCategoriesView.h
//  Penguin
//
//  Created by Jing Dai on 8/26/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGChannelCategory.h"

@protocol PGChannelCategoriesViewDelegate <NSObject>

- (void)categoryDidSelect:(PGChannelCategory *)category;

@end

@interface PGChannelCategoriesView : UIView

@property (nonatomic, weak) id<PGChannelCategoriesViewDelegate> delegate;

- (void)reloadViewWithCategories:(NSArray *)categoriesArray;

@end
