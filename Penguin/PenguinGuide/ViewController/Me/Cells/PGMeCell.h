//
//  PGMeCell.h
//  Penguin
//
//  Created by Jing Dai on 23/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGMeCell : PGBaseCollectionViewCell

- (void)setCellWithName:(NSString *)name highlight:(BOOL)highlight;

+ (CGSize)cellSize;

@end
