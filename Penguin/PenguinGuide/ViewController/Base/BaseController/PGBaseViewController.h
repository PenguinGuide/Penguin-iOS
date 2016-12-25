//
//  PGBaseViewController.h
//  Penguin
//
//  Created by Jing Dai on 7/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAPIClient.h"
#import "FBKVOController.h"
#import "PGBaseViewModel.h"

// navigation bar
#import "UINavigationBar+PGTransparentNaviBar.h"

// popups
#import "UIView+PGToast.h"
#import "PGAlertController.h"
#import "PGPopupViewController.h"

#import "PGAnalytics.h"

@interface PGBaseViewController : UIViewController

@property (nonatomic, strong, readonly) PGAPIClient *apiClient;
@property (nonatomic, strong, readonly) FBKVOController *KVOController;

- (void)setNavigationTitle:(NSString *)title;
- (void)setTransparentNavigationBar:(UIColor *)tintColor;
- (void)resetTransparentNavigationBar;

- (void)observe:(id)object keyPath:(NSString *)keyPath block:(void(^)(id changedObject))block;
- (void)unobserve;
- (void)observeCollectionView:(PGBaseCollectionView *)collectionView endOfFeeds:(PGBaseViewModel *)viewModel;

- (void)backButtonClicked;

- (void)showToast:(NSString *)message;
- (void)showToast:(NSString *)message position:(PGToastPosition)position;
- (void)showAlert:(NSString *)title message:(NSString *)message actions:(NSArray *)actions style:(void (^)(PGAlertStyle *))styleConfig;
- (void)showLoading;
- (void)showOccupiedLoading;
- (void)dismissLoading;

- (void)showPopup:(UIView *)popupView;
- (void)dismissPopup;

- (void)showPlaceholder:(NSString *)image desc:(NSString *)desc;
- (void)showNetworkLostPlaceholder;

- (void)observeError:(PGBaseViewModel *)viewModel;
- (void)showErrorMessage:(NSError *)error;

@end
