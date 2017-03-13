//
//  PGBaseCollectionViewDelegate.m
//  Penguin
//
//  Created by Kobe Dai on 06/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGBaseCollectionViewDelegate.h"

@interface PGBaseCollectionViewDelegate ()

@property (nonatomic, weak) id<UICollectionViewDelegate, UICollectionViewDelegateFlowLayout> viewController;

@property (nonatomic, assign) CGFloat minimumLineSpacing;
@property (nonatomic, assign) CGFloat minimumInteritemSpacing;
@property (nonatomic, assign) UIEdgeInsets insets;
@property (nonatomic, assign) CGSize cellSize;
@property (nonatomic, assign) CGSize headerSize;
@property (nonatomic, assign) CGSize footerSize;

@end

@implementation PGBaseCollectionViewDelegate

+ (PGBaseCollectionViewDelegate *)delegateWithViewController:(id<UICollectionViewDelegate,UICollectionViewDelegateFlowLayout>)viewController
                                          minimumLineSpacing:(CGFloat)minimumLineSpacing
                                     minimumInteritemSpacing:(CGFloat)minimumInteritemSpacing
                                                      insets:(UIEdgeInsets)insets
                                                    cellSize:(CGSize)cellSize
{
    PGBaseCollectionViewDelegate *delegate = [[PGBaseCollectionViewDelegate alloc] init];
    
    delegate.viewController = viewController;
    delegate.minimumLineSpacing = minimumLineSpacing;
    delegate.minimumInteritemSpacing = minimumInteritemSpacing;
    delegate.insets = insets;
    delegate.cellSize = cellSize;
    
    return delegate;
}

// if aSelector is not found in this class, will call this method
- (id)forwardingTargetForSelector:(SEL)aSelector
{
    if ([self.viewController respondsToSelector:aSelector]) {
        return self.viewController;
    }
    return nil;
}

/**
    不过消息转发虽然类似于继承，但NSObject的一些方法还是能区分两者。如respondsToSelector:和isKindOfClass:只能用于继承体系，
    而不能用于转发链。如果我们想让这种消息转发看起来像是继承，则可以重写这些方法
 */
- (BOOL)respondsToSelector:(SEL)aSelector
{
    if ([super respondsToSelector:aSelector]) {
        return YES;
    } else {
        /**
            Here, test whether the aSelector message can be forwarded to another object
            and whether that object can respond to it. Return YES if it can.
         */
        if ([self.viewController respondsToSelector:aSelector]) {
            return YES;
        }
    }
    return NO;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return self.minimumLineSpacing;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return self.minimumInteritemSpacing;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return self.insets;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return self.cellSize;
}

@end
