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
#import "PGSettingsUpdateViewController.h"
#import "PGSettingsCell.h"
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
    
    [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor clearColor]];
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
            [cell setCellWithDesc:@"头 像" content:self.viewModel.me.avatar isImage:YES];
        } else if (indexPath.item == 1) {
            [cell setCellWithDesc:@"昵 称" content:self.viewModel.me.nickname isImage:NO];
        } else if (indexPath.item == 2) {
            if ([self.viewModel.me.sex isEqualToString:@"男"]) {
                [cell setCellWithDesc:@"性 别" content:@"男" isImage:NO];
            } else {
                [cell setCellWithDesc:@"性 别" content:@"女" isImage:NO];
            }
        } else if (indexPath.item == 3) {
            [cell setCellWithDesc:@"城 市" content:self.viewModel.me.location isImage:NO];
        } else if (indexPath.item == 4) {
            [cell setCellWithDesc:@"生 日" content:self.viewModel.me.birthday isImage:NO];
        } else if (indexPath.item == 5) {
            if (self.viewModel.me.hasPassword) {
                [cell setCellWithDesc:@"密 码" content:@"已设置" isImage:NO];
            } else {
                [cell setCellWithDesc:@"密 码" content:@"未设置" isImage:NO];
            }
        }
        
        return cell;
    } else if (indexPath.section == 1) {
        PGSettingsCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:SettingCell forIndexPath:indexPath];
        
        if (indexPath.item == 0) {
            [cell setCellWithDesc:@"手 机 号" content:self.viewModel.me.phoneNumber isImage:NO];
        } else if (indexPath.item == 1) {
            if (self.viewModel.me.weixinBinded) {
                [cell setCellWithDesc:@"微 信" content:@"已绑定" isImage:NO];
            } else {
                [cell setCellWithDesc:@"微 信" content:@"未绑定" isImage:NO];
            }
        } else if (indexPath.item == 2) {
            if (self.viewModel.me.weiboBinded) {
                [cell setCellWithDesc:@"微 博" content:@"已绑定" isImage:NO];
            } else {
                [cell setCellWithDesc:@"微 博" content:@"未绑定" isImage:NO];
            }
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

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        if (indexPath.item == 0) {
            UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
            imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            imagePickerController.allowsEditing = YES;
            imagePickerController.delegate = self;
            
            [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
        } else if (indexPath.item == 1) {
            PGSettingsUpdateViewController *settingsUpdateVC = [[PGSettingsUpdateViewController alloc] initWithType:PGSettingsTypeNickname content:self.viewModel.me.nickname];
            [self.navigationController pushViewController:settingsUpdateVC animated:YES];
        } else if (indexPath.item == 2) {
            PGSettingsUpdateViewController *settingsUpdateVC = [[PGSettingsUpdateViewController alloc] initWithType:PGSettingsTypeSex content:self.viewModel.me.sex];
            [self.navigationController pushViewController:settingsUpdateVC animated:YES];
        } else if (indexPath.item == 3) {
            PGSettingsUpdateViewController *settingsUpdateVC = [[PGSettingsUpdateViewController alloc] initWithType:PGSettingsTypeLocation content:self.viewModel.me.location];
            [self.navigationController pushViewController:settingsUpdateVC animated:YES];
        } else if (indexPath.item == 4) {
            PGSettingsUpdateViewController *settingsUpdateVC = [[PGSettingsUpdateViewController alloc] initWithType:PGSettingsTypeBirthday content:self.viewModel.me.birthday];
            [self.navigationController pushViewController:settingsUpdateVC animated:YES];
        }
    } else if (indexPath.section == 1) {
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
