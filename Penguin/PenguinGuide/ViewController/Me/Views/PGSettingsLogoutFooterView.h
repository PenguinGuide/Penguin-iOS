//
//  PGSettingsLogoutFooterView.h
//  Penguin
//
//  Created by Jing Dai on 07/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGSettingsLogoutFooterView : UICollectionReusableView

@property (nonatomic, strong) UIButton *logoutButton;
@property (nonatomic, copy) void (^openDeveloperPageHandler)();

@end
