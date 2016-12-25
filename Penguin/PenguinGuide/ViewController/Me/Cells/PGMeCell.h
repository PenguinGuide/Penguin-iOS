//
//  PGMeCell.h
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGMeCell : UICollectionViewCell

- (void)setCellWithIcon:(NSString *)icon name:(NSString *)name count:(NSString *)count;
- (void)setCellWithIcon:(NSString *)icon name:(NSString *)name highlight:(BOOL)highlight;

+ (CGSize)cellSize;

@end
