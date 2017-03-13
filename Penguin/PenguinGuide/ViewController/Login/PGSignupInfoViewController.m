//
//  PGSignupInfoViewController.m
//  Penguin
//
//  Created by Jing Dai on 19/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

typedef NS_ENUM(NSInteger, PGTextFieldTag) {
    PGTextFieldTagNickname,
    PGTextFieldTagDOB,
    PGTextFieldTagSex,
    PGTextFieldTagLocation
};

#import "PGSignupInfoViewController.h"
#import "PGLoginTextField.h"
#import "UIButton+WebCache.h"
#import "PGQiniuUploadImageManager.h"

@interface PGSignupInfoViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, strong) UIButton *cameraButton;
@property (nonatomic, strong) PGLoginTextField *nicknameTextField;
@property (nonatomic, strong) PGLoginTextField *dobTextField;
@property (nonatomic, strong) PGLoginTextField *sexTextField;
@property (nonatomic, strong) PGLoginTextField *locationTextField;
@property (nonatomic, strong) UIButton *doneButton;
@property (nonatomic, strong) UIButton *skipButton;

@property (nonatomic, strong) UIDatePicker *dobPicker;
@property (nonatomic, strong) UIPickerView *sexPicker;
@property (nonatomic, strong) UIPickerView *cityPicker;
@property (nonatomic, strong) NSDateFormatter *df;

@property (nonatomic, strong) NSArray *provincesArray;
@property (nonatomic, strong) NSArray *districtsArray;
@property (nonatomic, assign) NSInteger currentIndex;

@property (nonatomic, strong) NSString *avatarUrl;

@end

@implementation PGSignupInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.closeButton.hidden = YES;
    self.backButton.hidden = YES;
    self.logoImageView.hidden = YES;
    
    [self.loginScrollView addSubview:self.cameraButton];
    [self.loginScrollView addSubview:self.nicknameTextField];
    [self.loginScrollView addSubview:self.dobTextField];
    [self.loginScrollView addSubview:self.sexTextField];
    [self.loginScrollView addSubview:self.locationTextField];
    [self.loginScrollView addSubview:self.doneButton];
    [self.loginScrollView addSubview:self.skipButton];
    
    NSDictionary *citiesDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pg_cities_list" ofType:@"plist"]];
    self.provincesArray = citiesDict.allKeys;
    NSMutableArray *citiesArray = [NSMutableArray new];
    for (NSString *province in self.provincesArray) {
        NSArray *cities = citiesDict[province];
        [citiesArray addObject:cities];
    }
    self.districtsArray = [NSArray arrayWithArray:citiesArray];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.nicknameTextField resignFirstResponder];
    [self.dobTextField resignFirstResponder];
    [self.sexTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
}

#pragma mark - <UITextFieldDelegate>

- (void)textFieldDidBeginEditing:(UITextField *)textField
{
    if (textField.tag == PGTextFieldTagSex) {
        if (!textField.text || [textField.text isEqualToString:@""]) {
            textField.text = @"男";
        }
    }
}

#pragma mark - <UIPickerViewDataSource>

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    if (pickerView.tag == 0) {
        return 1;
    } else if (pickerView.tag == 1) {
        return 2;
    }
    return 0;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
        return 2;
    } else if (pickerView.tag == 1) {
        if (component == 0) {
            return self.provincesArray.count;
        } else if (component == 1) {
            return [self.districtsArray[self.currentIndex] count];
        }
    }
    return 0;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
        if (row == 0) {
            return @"男";
        } else {
            return @"女";
        }
    } else if (pickerView.tag == 1) {
        if (component == 0) {
            return self.provincesArray[row];
        } else if (component == 1) {
            return self.districtsArray[self.currentIndex][row];
        }
    }
    return nil;
}

#pragma mark - <UIPickerViewDelegate>

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    if (pickerView.tag == 0) {
        if (row == 0) {
            self.sexTextField.text = @"男";
        } else {
            self.sexTextField.text = @"女";
        }
    } else if (pickerView.tag == 1) {
        if (component == 0) {
            self.currentIndex = row;
            [self.cityPicker reloadComponent:1];
            [self.cityPicker selectRow:0 inComponent:1 animated:YES];
        }
        NSInteger selectedProvinceRow = [pickerView selectedRowInComponent:0];
        NSInteger selectedCityRow = [pickerView selectedRowInComponent:1];
        NSString *province = self.provincesArray[selectedProvinceRow];
        NSString *city = self.districtsArray[selectedProvinceRow][selectedCityRow];
        self.locationTextField.text = [NSString stringWithFormat:@"%@ %@", province, city];
    }

}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    NSDate *date = datePicker.date;
    self.dobTextField.text = [self.df stringFromDate:date];
}

#pragma mark - <Button Evvents>

- (void)cameraButtonClicked
{
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    imagePickerController.allowsEditing = YES;
    imagePickerController.delegate = self;
    
    [self.navigationController presentViewController:imagePickerController animated:YES completion:nil];
}

- (void)doneButtonClicked
{
    if (self.userId) {
        PGParams *params = [PGParams new];
        params[@"nick_name"] = self.nicknameTextField.text;
        params[@"gender"] = self.sexTextField.text;
        params[@"birth"] = self.dobTextField.text;
        params[@"location"] = self.locationTextField.text;
        params[@"avatar_url"] = self.avatarUrl;
        
        [self showLoading];
        
        PGWeakSelf(self);
        
        [self.apiClient pg_makePatchRequest:^(PGRKRequestConfig *config) {
            config.route = PG_User;
            config.params = params;
            config.keyPath = nil;
            config.pattern = @{@"userId":weakself.userId};
        } completion:^(id response) {
            [[NSNotificationCenter defaultCenter] postNotificationName:PG_NOTIFICATION_LOGIN object:nil];
            [weakself dismissLoading];
            [weakself dismissViewControllerAnimated:YES completion:nil];
        } failure:^(NSError *error) {
            [weakself dismissLoading];
            [weakself showErrorMessage:error];
        }];
    }
}

- (void)skipButtonClicked
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)accessoryDoneButtonClicked
{
    [self.dobTextField resignFirstResponder];
    [self.sexTextField resignFirstResponder];
    [self.locationTextField resignFirstResponder];
}

#pragma mark - <UIImagePickerControllerDelegate>

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    __block UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (image) {
        [self showOccupiedLoading];
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
                        weakself.avatarUrl = url;
                        [weakself.cameraButton setImage:image forState:UIControlStateNormal];
                        [weakself dismissLoading];
                    } failure:^(NSError *error) {
                        [weakself showErrorMessage:error];
                        [weakself dismissLoading];
                    }];
                } else {
                    // TODO: user logout
                }
            } else {
                [weakself showToast:@"上传失败" position:PGToastPositionBottom];
            }
            [weakself dismissLoading];
            [picker dismissViewControllerAnimated:YES completion:nil];
        }];
    }
    [picker dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - <Setters && Getters>

- (UIButton *)cameraButton
{
    if (!_cameraButton) {
        _cameraButton = [[UIButton alloc] initWithFrame:CGRectMake((UISCREEN_WIDTH-92)/2, 50, 92, 92)];
        _cameraButton.clipsToBounds = YES;
        _cameraButton.layer.cornerRadius = 46;
        [_cameraButton addTarget:self action:@selector(cameraButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_cameraButton setImage:[UIImage imageNamed:@"pg_login_camera"] forState:UIControlStateNormal];
        if (self.userAvatar && self.userAvatar.length > 0) {
            [_cameraButton sd_setImageWithURL:[NSURL URLWithString:self.userAvatar] forState:UIControlStateNormal];
        }
    }
    return _cameraButton;
}

- (PGLoginTextField *)nicknameTextField
{
    if (!_nicknameTextField) {
        _nicknameTextField = [[PGLoginTextField alloc] initWithFrame:CGRectMake(45, self.cameraButton.pg_bottom+40, UISCREEN_WIDTH-90, 40)];
        _nicknameTextField.placeholder = @"请输入昵称";
        _nicknameTextField.delegate = self;
        if (self.userNickname && self.userNickname.length > 0) {
            _nicknameTextField.text = self.userNickname;
        }
    }
    return _nicknameTextField;
}

- (PGLoginTextField *)dobTextField
{
    if (!_dobTextField) {
        _dobTextField = [[PGLoginTextField alloc] initWithFrame:CGRectMake(45, self.nicknameTextField.pg_bottom+15, UISCREEN_WIDTH-90, 40)];
        _dobTextField.inputView = self.dobPicker;
        _dobTextField.inputAccessoryView = self.accessoryView;
        _dobTextField.placeholder = @"选择你的出生年月";
        _dobTextField.delegate = self;
        _dobTextField.tag = PGTextFieldTagDOB;
    }
    return _dobTextField;
}

- (PGLoginTextField *)sexTextField
{
    if (!_sexTextField) {
        _sexTextField = [[PGLoginTextField alloc] initWithFrame:CGRectMake(45, self.dobTextField.pg_bottom+15, UISCREEN_WIDTH-90, 40)];
        _sexTextField.inputView = self.sexPicker;
        _sexTextField.inputAccessoryView = self.accessoryView;
        _sexTextField.placeholder = @"选择你的性别";
        _sexTextField.delegate = self;
        _sexTextField.tag = PGTextFieldTagSex;
    }
    return _sexTextField;
}

- (PGLoginTextField *)locationTextField
{
    if (!_locationTextField) {
        _locationTextField = [[PGLoginTextField alloc] initWithFrame:CGRectMake(45, self.sexTextField.pg_bottom+15, UISCREEN_WIDTH-90, 40)];
        _locationTextField.inputView = self.cityPicker;
        _locationTextField.inputAccessoryView = self.accessoryView;
        _locationTextField.placeholder = @"选择你的地区";
        _locationTextField.delegate = self;
        _locationTextField.tag = PGTextFieldTagLocation;
    }
    return _locationTextField;
}

- (UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(45, UISCREEN_HEIGHT-100-32, UISCREEN_WIDTH-90, 32)];
        _doneButton.clipsToBounds = YES;
        _doneButton.layer.cornerRadius = 16.f;
        [_doneButton setBackgroundColor:[UIColor whiteColor]];
        [_doneButton setTitle:@"完 成 注 册" forState:UIControlStateNormal];
        [_doneButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [_doneButton.titleLabel setFont:Theme.fontMediumBold];
        [_doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

- (UIButton *)skipButton
{
    if (!_skipButton) {
        _skipButton = [[UIButton alloc] initWithFrame:CGRectMake(45, self.doneButton.pg_bottom+35, UISCREEN_WIDTH-90, 32)];
        [_skipButton setTitle:@"跳过此步骤" forState:UIControlStateNormal];
        [_skipButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [_skipButton.titleLabel setFont:Theme.fontMediumBold];
        [_skipButton addTarget:self action:@selector(skipButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _skipButton;
}

- (UIDatePicker *)dobPicker
{
    if (!_dobPicker) {
        _dobPicker = [[UIDatePicker alloc] init];
        _dobPicker.datePickerMode = UIDatePickerModeDate;
        [_dobPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
    }
    return _dobPicker;
}

- (UIPickerView *)sexPicker
{
    if (!_sexPicker) {
        _sexPicker = [[UIPickerView alloc] init];
        _sexPicker.dataSource = self;
        _sexPicker.delegate = self;
        _sexPicker.tag = 0;
    }
    return _sexPicker;
}

- (UIPickerView *)cityPicker
{
    if (!_cityPicker) {
        _cityPicker = [[UIPickerView alloc] init];
        _cityPicker.dataSource = self;
        _cityPicker.delegate = self;
        _cityPicker.tag = 1;
    }
    return _cityPicker;
}

- (NSDateFormatter *)df
{
    if (!_df) {
        _df = [[NSDateFormatter alloc] init];
        [_df setDateFormat:@"yyyy-MM-dd"];
    }
    return _df;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
