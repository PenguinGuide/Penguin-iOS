//
//  PGPagedBannersCell.h
//  Penguin
//
//  Created by Jing Dai on 7/10/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGPagedScrollView.h"

@interface PGPagedBannersCell : UICollectionViewCell

@property (nonatomic, strong, readonly) PGPagedScrollView *bannersView;

- (void)reloadBannersWithData:(NSArray *)dataArray;

@end
