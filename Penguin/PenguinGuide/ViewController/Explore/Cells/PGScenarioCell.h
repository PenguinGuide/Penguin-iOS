//
//  PGScenarioCell.h
//  Penguin
//
//  Created by Jing Dai on 29/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGScenarioCell : PGBaseCollectionViewCell

- (void)reloadWithBanners:(NSArray *)banners title:(NSString *)title scenarioType:(NSString *)scenarioType;

+ (CGSize)cellSize;

@end
