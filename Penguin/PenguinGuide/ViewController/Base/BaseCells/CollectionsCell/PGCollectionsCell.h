//
//  PGCollectionsCell.h
//  Penguin
//
//  Created by Kobe Dai on 16/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGBaseCollectionViewCell.h"

@interface PGCollectionsCellConfig : NSObject

@property (nonatomic, assign) CGFloat titleHeight;
@property (nonatomic, assign) CGSize collectionCellSize;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) BOOL showBorder;
@property (nonatomic, strong) NSString *moreCellLink;

@end

typedef void (^PGCollectionsCellConfigBlock)(PGCollectionsCellConfig *config);

@interface PGCollectionsCell : PGBaseCollectionViewCell

- (void)setCellWithTitle:(NSAttributedString *)title
             collections:(NSArray *)collections
               cellClass:(Class)CellClass
                  config:(PGCollectionsCellConfigBlock)configBlock;

@end
