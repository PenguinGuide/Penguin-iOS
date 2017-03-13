//
//  PGBaseCollectionViewDelegate.h
//  Penguin
//
//  Created by Kobe Dai on 06/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGBaseViewController.h"

@interface PGBaseCollectionViewDelegate : NSObject <UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

+ (PGBaseCollectionViewDelegate *)delegateWithViewController:(id<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>)viewController
                                          minimumLineSpacing:(CGFloat)minimumLineSpacing
                                     minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
                                                      insets:(UIEdgeInsets)insets
                                                    cellSize:(CGSize)cellSize;

@end
