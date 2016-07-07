//
//  PGUpdatePasswordView.h
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginBaseView.h"
#import "PGLoginPasswordTextField.h"

@interface PGUpdatePasswordView : PGLoginBaseView

@property (nonatomic, strong, readonly) PGLoginPasswordTextField *pwdTextField;
@property (nonatomic, strong, readonly) UIButton *updatePwdButton;

@end
