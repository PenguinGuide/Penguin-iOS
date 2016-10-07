//
//  PGPersonalSettingsViewController.m
//  Penguin
//
//  Created by Jing Dai on 26/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define SettingCell @"SettingCell"
#define SettingHeaderView @"SettingHeaderView"

#import "PGPersonalSettingsViewController.h"
#import "PGSettingsCell.h"
#import "PGSettingsHeaderView.h"

#import "UINavigationBar+PGTransparentNaviBar.h"

@interface PGPersonalSettingsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *settingsCollectionView;

@end

@implementation PGPersonalSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.settingsCollectionView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor clearColor]];
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
        return 6;
    } else if (section == 1) {
        return 3;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PGSettingsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SettingCell forIndexPath:indexPath];
        
        if (indexPath.item == 0) {
            [cell setCellWithDesc:@"头 像" content:@"https://i.imgsafe.org/2590228277.jpg" isImage:YES];
        } else if (indexPath.item == 1) {
            [cell setCellWithDesc:@"昵 称" content:@"KobeKK" isImage:NO];
        } else if (indexPath.item == 2) {
            [cell setCellWithDesc:@"性 别" content:@"男" isImage:NO];
        } else if (indexPath.item == 3) {
            [cell setCellWithDesc:@"城 市" content:@"上海" isImage:NO];
        } else if (indexPath.item == 4) {
            [cell setCellWithDesc:@"生 日" content:@"12.19" isImage:NO];
        } else if (indexPath.item == 5) {
            [cell setCellWithDesc:@"密 码" content:@"未设置" isImage:NO];
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        PGSettingsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SettingCell forIndexPath:indexPath];
        
        if (indexPath.item == 0) {
            [cell setCellWithDesc:@"手 机 号" content:@"18521001948" isImage:NO];
        } else if (indexPath.item == 1) {
            [cell setCellWithDesc:@"微 信" content:@"已绑定" isImage:NO];
        } else if (indexPath.item == 2) {
            [cell setCellWithDesc:@"微 博" content:@"未绑定" isImage:NO];
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(UISCREEN_WIDTH, 50);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    return CGSizeMake(UISCREEN_WIDTH, 68);
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
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 0) {
            PGSettingsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SettingHeaderView forIndexPath:indexPath];
            [headerView setHeaderViewWithTitle:@"个人设置"];
            
            return headerView;
        } else if (indexPath.section == 1) {
            PGSettingsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SettingHeaderView forIndexPath:indexPath];
            [headerView setHeaderViewWithTitle:@"账号绑定"];
            
            return headerView;
        }
    }
    
    return nil;
}

- (PGBaseCollectionView *)settingsCollectionView
{
    if (!_settingsCollectionView) {
        _settingsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, -20, UISCREEN_WIDTH, UISCREEN_HEIGHT+20) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _settingsCollectionView.dataSource = self;
        _settingsCollectionView.delegate = self;
        _settingsCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_settingsCollectionView registerClass:[PGSettingsCell class] forCellWithReuseIdentifier:SettingCell];
        [_settingsCollectionView registerClass:[PGSettingsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SettingHeaderView];
    }
    return _settingsCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
