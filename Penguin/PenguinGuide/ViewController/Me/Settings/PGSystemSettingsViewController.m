//
//  PGSystemSettingsViewController.m
//  Penguin
//
//  Created by Jing Dai on 26/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define SettingCell @"SettingCell"
#define TaoBaoCell @"TaoBaoCell"
#define SettingHeaderView @"SettingHeaderView"
#define LogoutFooterView @"LogoutFooterView"

#import "PGSystemSettingsViewController.h"
#import "PGDeveloperViewController.h"
#import "PGSystemSettingsCell.h"
#import "PGSystemSettingsTaobaoCell.h"
#import "PGSettingsLogoutFooterView.h"
#import "PGAlibcTraderManager.h"

#import "SDImageCache.h"

@interface PGSystemSettingsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *settingsCollectionView;

@end

@implementation PGSystemSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"系统设置"];
    
    [self.view addSubview:self.settingsCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar pg_reset];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 2;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
#if (defined DEBUG)
        return 6;
#else
        return 5;
#endif
    } else if (section == 1) {
        return 1;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PGSystemSettingsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SettingCell forIndexPath:indexPath];
        
        if (indexPath.item == 0) {
            [cell setCellWithDesc:@"清 除 缓 存"];
        } else if (indexPath.item == 1) {
            [cell setCellWithDesc:@"关 于 我 们"];
        } else if (indexPath.item == 2) {
            [cell setCellWithDesc:@"联 系 我 们"];
        } else if (indexPath.item == 3) {
            [cell setCellWithDesc:@"用 户 协 议"];
        } else if (indexPath.item == 4) {
            [cell setCellWithDesc:@"评 分"];
        } else if (indexPath.item == 5) {
            [cell setCellWithDesc:@"开 发 者 页 面"];
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        PGSystemSettingsTaobaoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TaoBaoCell forIndexPath:indexPath];
        
        [cell setCellWithAuthorized:[PGAlibcTraderManager isUserLogin]];
        
        return cell;
    }
    
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(UISCREEN_WIDTH, 60);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 0) {
        return CGSizeMake(UISCREEN_WIDTH, 20);
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 1) {
        return CGSizeMake(UISCREEN_WIDTH, 70);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (kind == UICollectionElementKindSectionHeader) {
            if (indexPath.section == 0) {
                UICollectionReusableView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SettingHeaderView forIndexPath:indexPath];
                
                return headerView;
            }
        }
    } else if (indexPath.section == 1) {
        if (kind == UICollectionElementKindSectionFooter) {
            PGSettingsLogoutFooterView *footerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:LogoutFooterView forIndexPath:indexPath];
            [footerView.logoutButton addTarget:self action:@selector(logoutButtonClicked) forControlEvents:UIControlEventTouchUpInside];
            
            return footerView;
        }
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            PGAlertAction *cancelAction = [PGAlertAction actionWithTitle:@"取消" style:^(PGAlertActionStyle *style) {
                
            } handler:^{
                
            }];
            PGAlertAction *doneAction = [PGAlertAction actionWithTitle:@"确定" style:^(PGAlertActionStyle *style) {
                style.type = PGAlertActionTypeDestructive;
            } handler:^{
                [[SDImageCache sharedImageCache] clearDiskOnCompletion:nil];
                [[SDImageCache sharedImageCache] clearMemory];
            }];
            [self showAlert:@"清除缓存" message:@"确定清除缓存？" actions:@[cancelAction, doneAction] style:^(PGAlertStyle *style) {
                style.alertType = PGAlertTypeAlert;
            }];
        } else if (indexPath.item == 5) {
#if (defined DEBUG)
            PGDeveloperViewController *developerVC = [[PGDeveloperViewController alloc] init];
            [self.navigationController pushViewController:developerVC animated:YES];
#endif
        }
    } else if (indexPath.section == 1) {
        PGWeakSelf(self);
        if ([PGAlibcTraderManager isUserLogin]) {
            PGAlertAction *cancelAction = [PGAlertAction actionWithTitle:@"取消" style:^(PGAlertActionStyle *style) {
                
            } handler:^{
                
            }];
            PGAlertAction *doneAction = [PGAlertAction actionWithTitle:@"确定" style:^(PGAlertActionStyle *style) {
                style.type = PGAlertActionTypeDestructive;
            } handler:^{
                [PGAlibcTraderManager logout];
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.4 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    [weakself.settingsCollectionView reloadData];
                });
            }];
            [self showAlert:@"退出淘宝登录" message:@"确定退出淘宝登录？" actions:@[cancelAction, doneAction] style:^(PGAlertStyle *style) {
                style.alertType = PGAlertTypeAlert;
            }];
        } else {
            [PGAlibcTraderManager login:^(BOOL success) {
                if (success) {
                    [weakself showToast:@"淘宝登录成功"];
                    [weakself.settingsCollectionView reloadData];
                } else {
                    [weakself showToast:@"淘宝登录失败"];
                }
            }];
        }
    }
}

#pragma mark - <Button Events>

- (void)logoutButtonClicked
{
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_LOGOUT object:nil];
    
    [PGGlobal synchronizeUserId:nil];
    [PGGlobal synchronizeToken:nil];
    [PGShareManager logout];
    
    [PGRouterManager routeToLoginPage];
}

- (PGBaseCollectionView *)settingsCollectionView
{
    if (!_settingsCollectionView) {
        _settingsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _settingsCollectionView.dataSource = self;
        _settingsCollectionView.delegate = self;
        _settingsCollectionView.backgroundColor = [UIColor whiteColor];
        _settingsCollectionView.showsHorizontalScrollIndicator = NO;
        _settingsCollectionView.showsVerticalScrollIndicator = NO;
        
        [_settingsCollectionView registerClass:[PGSystemSettingsCell class] forCellWithReuseIdentifier:SettingCell];
        [_settingsCollectionView registerClass:[PGSystemSettingsTaobaoCell class] forCellWithReuseIdentifier:TaoBaoCell];
        [_settingsCollectionView registerClass:[UICollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SettingHeaderView];
        [_settingsCollectionView registerClass:[PGSettingsLogoutFooterView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:LogoutFooterView];
    }
    return _settingsCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
