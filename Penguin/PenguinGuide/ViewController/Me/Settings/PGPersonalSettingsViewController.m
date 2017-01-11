//
//  PGPersonalSettingsViewController.m
//  Penguin
//
//  Created by Jing Dai on 26/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define AvatarCell @"AvatarCell"
#define SettingCell @"SettingCell"
#define SettingHeaderView @"SettingHeaderView"

#import "PGPersonalSettingsViewController.h"
#import "PGSettingsUpdateViewController.h"
#import "PGPersonalSettingsCell.h"
#import "PGPersonalSettingsAvatarCell.h"
#import "PGSettingsHeaderView.h"

#import "PGMeViewModel.h"

#import "UINavigationBar+PGTransparentNaviBar.h"

#import "PGQiniuUploadImageManager.h"

@interface PGPersonalSettingsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) PGBaseCollectionView *settingsCollectionView;
@property (nonatomic, strong) PGMeViewModel *viewModel;

@end

@implementation PGPersonalSettingsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self setNavigationTitle:@"个人设置"];
    
    [self.view addSubview:self.settingsCollectionView];
    
    self.viewModel = [[PGMeViewModel alloc] initWithAPIClient:self.apiClient];
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"me" block:^(id changedObject) {
        PGMe *me = changedObject;
        if (me && [me isKindOfClass:[PGMe class]]) {
            [weakself.settingsCollectionView reloadData];
        }
        [weakself dismissLoading];
    }];
    [self observeError:self.viewModel];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor whiteColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    
    if (!self.viewModel.me) {
        [self showOccupiedLoading];
        [self.viewModel requestDetails];
    }
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar pg_reset];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 3;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return 1;
    } else if (section == 1) {
        return 5;
    } else if (section == 2) {
        return 3;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PGPersonalSettingsAvatarCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:AvatarCell forIndexPath:indexPath];
        
        [cell setCellWithAvatar:self.viewModel.me.avatar];
        
        return cell;
    } else if (indexPath.section == 1) {
        PGPersonalSettingsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SettingCell forIndexPath:indexPath];
        
        if (indexPath.item == 0) {
            [cell setCellWithDesc:@"昵 称" content:self.viewModel.me.nickname];
        } else if (indexPath.item == 1) {
            if ([self.viewModel.me.sex isEqualToString:@"男"]) {
                [cell setCellWithDesc:@"性 别" content:@"男"];
            } else {
                [cell setCellWithDesc:@"性 别" content:@"女"];
            }
        } else if (indexPath.item == 2) {
            [cell setCellWithDesc:@"城 市" content:self.viewModel.me.location];
        } else if (indexPath.item == 3) {
            [cell setCellWithDesc:@"生 日" content:self.viewModel.me.birthday];
        } else if (indexPath.item == 4) {
            if (self.viewModel.me.hasPassword) {
                [cell setCellWithDesc:@"密 码" content:@"已设置"];
            } else {
                [cell setCellWithDesc:@"密 码" content:@"未设置"];
            }
        }
        
        return cell;
    } else if (indexPath.section == 2) {
        PGPersonalSettingsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SettingCell forIndexPath:indexPath];
        
        if (indexPath.item == 0) {
            [cell setCellWithDesc:@"手 机 号" content:self.viewModel.me.phoneNumber];
        } else if (indexPath.item == 1) {
            if (self.viewModel.me.weixinBinded) {
                [cell setCellWithDesc:@"微 信" content:@"已绑定"];
            } else {
                [cell setCellWithDesc:@"微 信" content:@"未绑定"];
            }
        } else if (indexPath.item == 2) {
            if (self.viewModel.me.weiboBinded) {
                [cell setCellWithDesc:@"微 博" content:@"已绑定"];
            } else {
                [cell setCellWithDesc:@"微 博" content:@"未绑定"];
            }
        }
        
        return cell;
    }
    
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return CGSizeMake(UISCREEN_WIDTH, 20+80+20+16+20);
    } else {
        return CGSizeMake(UISCREEN_WIDTH, 50);
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 2) {
        return CGSizeMake(UISCREEN_WIDTH, 80);
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
    if (kind == UICollectionElementKindSectionHeader) {
        if (indexPath.section == 2) {
            PGSettingsHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:SettingHeaderView forIndexPath:indexPath];
            [headerView setHeaderViewWithTitle:@"账号绑定"];
            
            return headerView;
        }
    }
    
    return nil;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        imagePickerController.allowsEditing = YES;
        imagePickerController.delegate = self;
        
        [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
    } else if (indexPath.section == 1) {
        if (indexPath.item == 0) {
            PGSettingsUpdateViewController *settingsUpdateVC = [[PGSettingsUpdateViewController alloc] initWithType:PGSettingsTypeNickname content:self.viewModel.me.nickname];
            [self.navigationController pushViewController:settingsUpdateVC animated:YES];
        } else if (indexPath.item == 1) {
            PGSettingsUpdateViewController *settingsUpdateVC = [[PGSettingsUpdateViewController alloc] initWithType:PGSettingsTypeSex content:self.viewModel.me.sex];
            [self.navigationController pushViewController:settingsUpdateVC animated:YES];
        } else if (indexPath.item == 2) {
            PGSettingsUpdateViewController *settingsUpdateVC = [[PGSettingsUpdateViewController alloc] initWithType:PGSettingsTypeLocation content:self.viewModel.me.location];
            [self.navigationController pushViewController:settingsUpdateVC animated:YES];
        } else if (indexPath.item == 3) {
            PGSettingsUpdateViewController *settingsUpdateVC = [[PGSettingsUpdateViewController alloc] initWithType:PGSettingsTypeBirthday content:self.viewModel.me.birthday];
            [self.navigationController pushViewController:settingsUpdateVC animated:YES];
        }
    } else if (indexPath.section == 2) {
        if (indexPath.item == 0) {
            if (!self.viewModel.me.phoneNumber || self.viewModel.me.phoneNumber.length == 0) {
                
            }
        } else if (indexPath.item == 1) {
            if (!self.viewModel.me.weixinBinded) {
                PGWeakSelf(self);
                [PGShareManager loginWithWechatOnStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                    if (state == SSDKResponseStateSuccess) {
                        PGParams *params = [PGParams new];
                        params[@"openid"] = user.uid;
                        params[@"access_token"] = user.credential.token;
                        params[@"nick_name"] = user.nickname;
                        [weakself.apiClient pg_makePostRequest:^(PGRKRequestConfig *config) {
                            config.route = PG_User_Bind_Weixin;
                            config.params = params;
                            config.keyPath = nil;
                        } completion:^(id response) {
                            [weakself showToast:@"绑定成功"];
                        } failure:^(NSError *error) {
                            [weakself showErrorMessage:error];
                        }];
                    } else if (state == SSDKResponseStateCancel || state == SSDKResponseStateFail) {
                        [weakself showToast:@"绑定失败"];
                    }
                }];
            }
        } else if (indexPath.item == 2) {
            if (!self.viewModel.me.weiboBinded) {
                PGWeakSelf(self);
                [PGShareManager loginWithWeiboOnStateChanged:^(SSDKResponseState state, SSDKUser *user, NSError *error) {
                    if (state == SSDKResponseStateSuccess) {
                        PGParams *params = [PGParams new];
                        params[@"nick_name"] = user.nickname;
                        params[@"access_token"] = user.credential.token;
                        [weakself.apiClient pg_makePostRequest:^(PGRKRequestConfig *config) {
                            config.route = PG_User_Bind_Weibo;
                            config.params = params;
                            config.keyPath = nil;
                        } completion:^(id response) {
                            [weakself showToast:@"绑定成功"];
                        } failure:^(NSError *error) {
                            [weakself showErrorMessage:error];
                        }];
                    } else if (state == SSDKResponseStateCancel || state == SSDKResponseStateFail) {
                        [weakself showToast:@"绑定失败"];
                    }
                }];
            }
        }
    }
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    __block UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    if (image) {
        [self showLoading];
        PGWeakSelf(self);
        // NOTE: upload image with base64 data http://blog.csdn.net/a645258072/article/details/51728806
        [[PGQiniuUploadImageManager sharedManager] uploadImage:image completion:^(NSString *url) {
            if (url && url.length > 0) {
                if (PGGlobal.userId) {
                    PGParams *params = [PGParams new];
                    params[@"avatar_url"] = url;
                    [weakself showLoading];
                    PGWeakSelf(self);
                    [weakself.apiClient pg_makePatchRequest:^(PGRKRequestConfig *config) {
                        config.route = PG_User;
                        config.params = params;
                        config.keyPath = nil;
                        config.pattern = @{@"userId":PGGlobal.userId};
                    } completion:^(id response) {
                        [weakself dismissLoading];
                        [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_UPDATE_ME object:nil];
                        [weakself.navigationController popToRootViewControllerAnimated:YES];
                    } failure:^(NSError *error) {
                        [weakself showErrorMessage:error];
                        [weakself dismissLoading];
                    }];
                } else {
                    // TODO: user logout
                }
            } else {
                [weakself showToast:@"上传失败"];
            }
            [weakself dismissLoading];
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <Setters && Getters>

- (PGBaseCollectionView *)settingsCollectionView
{
    if (!_settingsCollectionView) {
        _settingsCollectionView = [[PGBaseCollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _settingsCollectionView.dataSource = self;
        _settingsCollectionView.delegate = self;
        _settingsCollectionView.backgroundColor = [UIColor whiteColor];
        _settingsCollectionView.showsHorizontalScrollIndicator = NO;
        _settingsCollectionView.showsVerticalScrollIndicator = NO;
        
        [_settingsCollectionView registerClass:[PGPersonalSettingsAvatarCell class] forCellWithReuseIdentifier:AvatarCell];
        [_settingsCollectionView registerClass:[PGPersonalSettingsCell class] forCellWithReuseIdentifier:SettingCell];
        [_settingsCollectionView registerClass:[PGSettingsHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:SettingHeaderView];
    }
    return _settingsCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
