//
//  PGTab.h
//  Penguin
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGTab : UIButton

@property (nonatomic, strong) NSString *tabTitle;
@property (nonatomic, strong) NSString *tabImage;
@property (nonatomic, strong) NSString *tabHighlightImage;
@property (nonatomic, assign) BOOL shouldShowDotView;

- (void)showDotView;
- (void)hideDotView;

@end
