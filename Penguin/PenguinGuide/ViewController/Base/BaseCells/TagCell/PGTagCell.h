//
//  PGTagCell.h
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGTagCell : UICollectionViewCell

- (void)setCellWithTagName:(NSString *)tagName;

+ (CGSize)cellSize:(NSString *)tagName;

@end
