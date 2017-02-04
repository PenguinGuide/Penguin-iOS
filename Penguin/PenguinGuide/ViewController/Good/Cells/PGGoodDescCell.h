//
//  PGGoodDescCell.h
//  Penguin
//
//  Created by Jing Dai on 28/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGGoodDescCell : PGBaseCollectionViewCell

- (void)setCellWithDesc:(NSString *)desc;

+ (CGSize)cellSize:(NSString *)desc;

@end
