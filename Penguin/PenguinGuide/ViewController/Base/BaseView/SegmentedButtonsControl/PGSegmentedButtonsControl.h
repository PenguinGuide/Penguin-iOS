//
//  PGSegmentedButtonsControl.h
//  Penguin
//
//  Created by Kobe Dai on 28/03/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

typedef void(^PGSegmentedButtonsControlIndexClicked)(NSInteger index);

#import <UIKit/UIKit.h>

@interface PGSegmentedButtonsControl : UIControl

@property (nonatomic, copy) PGSegmentedButtonsControlIndexClicked indexClickedBlock;

+ (PGSegmentedButtonsControl *)segmentedButtonsControlWithTitles:(NSArray *)titles images:(NSArray *)images segmentedButtonSize:(CGSize)buttonSize;

@end
