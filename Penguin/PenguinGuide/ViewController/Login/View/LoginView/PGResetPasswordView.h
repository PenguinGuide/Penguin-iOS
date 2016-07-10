//
//  PGResetPasswordView.h
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginBaseView.h"
#import "PGLoginPhoneTextField.h"
#import "PGLoginSMSCodeTextField.h"

@interface PGResetPasswordView : PGLoginBaseView

@property (nonatomic, strong, readonly) PGLoginPhoneTextField *phoneTextField;
@property (nonatomic, strong, readonly) PGLoginSMSCodeTextField *smsCodeTextField;
@property (nonatomic, strong, readonly) UIButton *resetPwdButton;

@end
