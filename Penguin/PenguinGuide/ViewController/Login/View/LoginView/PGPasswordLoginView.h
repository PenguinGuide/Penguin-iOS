//
//  PGPasswordLoginView.h
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginBaseView.h"
#import "PGLoginPhoneTextField.h"
#import "PGLoginPasswordTextField.h"

@interface PGPasswordLoginView : PGLoginBaseView

@property (nonatomic, strong, readonly) PGLoginPhoneTextField *phoneTextField;
@property (nonatomic, strong, readonly) PGLoginPasswordTextField *pwdTextField;
@property (nonatomic, strong, readonly) UIButton *forgotPwdButton;
@property (nonatomic, strong, readonly) UIButton *loginButton;

@end
