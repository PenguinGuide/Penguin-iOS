//
//  PGMeCell.h
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGMeCell : PGBaseCollectionViewCell

- (void)setCellWithName:(NSString *)name icon:(NSString *)icon highlight:(BOOL)highlight showHorizontalLine:(BOOL)showHorizontalLine;

+ (CGSize)cellSize;

@end
