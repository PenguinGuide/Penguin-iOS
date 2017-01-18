//
//  PGArticleParagraphTextCell.h
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGParserTextStorage.h"

@interface PGArticleParagraphTextCell : UICollectionViewCell

- (void)setCellWithStr:(NSAttributedString *)attrStr;

+ (CGSize)cellSize:(PGParserTextStorage *)textStorage;

@end
