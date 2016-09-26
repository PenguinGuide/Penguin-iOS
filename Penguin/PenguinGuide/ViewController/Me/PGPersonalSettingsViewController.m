//
//  PGPersonalSettingsViewController.m
//  Penguin
//
//  Created by Jing Dai on 26/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define SettingCell @"SettingCell"

#import "PGPersonalSettingsViewController.h"
#import "PGSettingsCell.h"

@interface PGPersonalSettingsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) PGBaseCollectionView *settingsCollectionView;

@end

@implementation PGPersonalSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (PGBaseCollectionView *)settingsCollectionView
{
    if (!_settingsCollectionView) {
        _settingsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 64, UISCREEN_WIDTH, UISCREEN_HEIGHT-64) collectionViewLayout:[UICollectionViewFlowLayout new]];
    }
    return _settingsCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
