//
//  PGSettingsUpdateViewController.m
//  Penguin
//
//  Created by Jing Dai on 24/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSettingsUpdateViewController.h"
#import "PGSettingsUpdateTextField.h"

@interface PGSettingsUpdateViewController () <UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate>

@property (nonatomic, assign) PGSettingsType settingType;
@property (nonatomic, strong) NSString *content;

@property (nonatomic, strong) PGSettingsUpdateTextField *updateTextField;

@property (nonatomic, strong) UIDatePicker *dobPicker;
@property (nonatomic, strong) UIPickerView *sexPicker;
@property (nonatomic, strong) UIPickerView *cityPicker;
@property (nonatomic, strong) UIView *accessoryView;
@property (nonatomic, strong) NSDateFormatter *df;

@property (nonatomic, strong) NSArray *provincesArray;
@property (nonatomic, strong) NSArray *districtsArray;
@property (nonatomic, assign) NSInteger currentIndex;

@end

@implementation PGSettingsUpdateViewController

- (id)initWithType:(PGSettingsType)setttingType content:(NSString *)content
{
    if (self = [super init]) {
        self.settingType = setttingType;
        self.content = content;
        
        if (self.settingType == PGSettingsTypeLocation) {
            NSDictionary *citiesDict = [[NSDictionary alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"pg_cities_list" ofType:@"plist"]];
            self.provincesArray = citiesDict.allKeys;
            NSMutableArray *citiesArray = [NSMutableArray new];
            for (NSString *province in self.provincesArray) {
                NSArray *cities = citiesDict[province];
                [citiesArray addObject:cities];
            }
            self.districtsArray = [NSArray arrayWithArray:citiesArray];
        }
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.updateTextField];
    
    UIBarButtonItem *saveButton = [[UIBarButtonItem alloc] initWithTitle:@"保存" style:UIBarButtonItemStyleDone target:self action:@selector(saveButtonClicked)];
    self.navigationController.navigationBar.tintColor = Theme.colorText;
    self.navigationItem.rightBarButtonItem = saveButton;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self.updateTextField becomeFirstResponder];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController.navigationBar pg_reset];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    
    [self.updateTextField resignFirstResponder];
}

- (void)reloadView
{
    [self hideNetworkLostPlaceholder];
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
            self.updateTextField.text = @"男";
        } else {
            self.updateTextField.text = @"女";
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
        self.updateTextField.text = [NSString stringWithFormat:@"%@ %@", province, city];
    }
}

- (void)datePickerValueChanged:(UIDatePicker *)datePicker
{
    NSDate *date = datePicker.date;
    self.updateTextField.text = [self.df stringFromDate:date];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        [textField resignFirstResponder];
        return YES;
    }
    
    return NO;
}

#pragma mark - <Button Events>

- (void)saveButtonClicked
{
    if (self.updateTextField.text && self.updateTextField.text.length > 0) {
        if (PGGlobal.userId) {
            PGParams *params = [PGParams new];
            
            if (self.settingType == PGSettingsTypeNickname) {
                params[@"nick_name"] = self.updateTextField.text;
            } else if (self.settingType == PGSettingsTypeSex) {
                params[@"gender"] = self.updateTextField.text;
            } else if (self.settingType == PGSettingsTypeLocation) {
                params[@"location"] = self.updateTextField.text;
            } else if (self.settingType == PGSettingsTypeBirthday) {
                params[@"birth"] = self.updateTextField.text;
            } else if (self.settingType == PGSettingsTypePassword) {
                
            }
            
            [self showLoading];
            
            PGWeakSelf(self);
            
            [self.apiClient pg_makePatchRequest:^(PGRKRequestConfig *config) {
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
    }
}

- (void)accessoryDoneButtonClicked
{
    [self.updateTextField resignFirstResponder];
    
    if (self.sexPicker) {
        
    } else if (self.cityPicker) {
        NSInteger selectedProvinceRow = [self.cityPicker selectedRowInComponent:0];
        NSInteger selectedCityRow = [self.cityPicker selectedRowInComponent:1];
        NSString *province = self.provincesArray[selectedProvinceRow];
        NSString *city = self.districtsArray[selectedProvinceRow][selectedCityRow];
        self.updateTextField.text = [NSString stringWithFormat:@"%@ %@", province, city];
    }
}

#pragma mark - <Setters && Getters>

- (PGSettingsUpdateTextField *)updateTextField
{
    if (!_updateTextField) {
        _updateTextField = [[PGSettingsUpdateTextField alloc] initWithFrame:CGRectMake(30, 64+20, UISCREEN_WIDTH-60, 40)];
        switch (self.settingType) {
            case PGSettingsTypeNickname:
                _updateTextField.placeholder = @"点击修改昵称";
                _updateTextField.clearButtonMode = UITextFieldViewModeAlways;
                _updateTextField.delegate = self;
                break;
            case PGSettingsTypeSex:
                _updateTextField.placeholder = @"点击修改性别";
                _updateTextField.inputView = self.sexPicker;
                _updateTextField.inputAccessoryView = self.accessoryView;
                break;
            case PGSettingsTypeLocation:
                _updateTextField.placeholder = @"点击修改城市";
                _updateTextField.inputView = self.cityPicker;
                _updateTextField.inputAccessoryView = self.accessoryView;
                break;
            case PGSettingsTypeBirthday:
                _updateTextField.placeholder = @"点击修改生日";
                _updateTextField.inputView = self.dobPicker;
                _updateTextField.inputAccessoryView = self.accessoryView;
                break;
            case PGSettingsTypePassword:
                _updateTextField.placeholder = @"输入密码";
                _updateTextField.secureTextEntry = YES;
                _updateTextField.clearButtonMode = UITextFieldViewModeAlways;
                break;
            default:
                break;
        }
        _updateTextField.text = self.content;
    }
    return _updateTextField;
}

- (UIDatePicker *)dobPicker
{
    if (!_dobPicker) {
        _dobPicker = [[UIDatePicker alloc] init];
        _dobPicker.datePickerMode = UIDatePickerModeDate;
        [_dobPicker addTarget:self action:@selector(datePickerValueChanged:) forControlEvents:UIControlEventValueChanged];
        
        NSDate *date = [self.df dateFromString:self.content];
        if (date) {
            [_dobPicker setDate:date animated:YES];
        }
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
        
        if ([self.content isEqualToString:@"男"]) {
            [_sexPicker selectRow:0 inComponent:0 animated:YES];
        } else {
            [_sexPicker selectRow:1 inComponent:0 animated:YES];
        }
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
        
        if (self.content && self.content.length > 0) {
            NSArray *cityComponents = [self.content componentsSeparatedByString:@" "];
            if (cityComponents.count == 2) {
                NSString *province = cityComponents[0];
                NSString *city = cityComponents[1];
                
                if ([self.provincesArray containsObject:province]) {
                    NSInteger provinceIndex = [self.provincesArray indexOfObject:province];
                    self.currentIndex = provinceIndex;
                    NSArray *citiesArray = self.districtsArray[provinceIndex];
                    if ([citiesArray containsObject:city]) {
                        NSInteger cityIndex = [citiesArray indexOfObject:city];
                        
                        [_cityPicker selectRow:provinceIndex inComponent:0 animated:YES];
                        [_cityPicker reloadComponent:1];
                        [_cityPicker selectRow:cityIndex inComponent:1 animated:YES];
                    }
                }
            }
        }
    }
    return _cityPicker;
}

- (UIView *)accessoryView
{
    if (!_accessoryView) {
        _accessoryView = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 44)];
        _accessoryView.backgroundColor = Theme.colorBackground;
        UIButton *doneButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-50, 0, 50, 44)];
        [doneButton addTarget:self action:@selector(accessoryDoneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [doneButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [doneButton setTitle:@"完成" forState:UIControlStateNormal];
        [doneButton.titleLabel setFont:Theme.fontMediumBold];
        [_accessoryView addSubview:doneButton];
    }
    return _accessoryView;
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
