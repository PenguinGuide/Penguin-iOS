//
//  PGRegisterUserInfoView.h
//  Penguin
//
//  Created by Jing Dai on 7/7/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginBaseView.h"
#import "PGLoginUserInfoTextField.h"

@interface PGRegisterUserInfoView : PGLoginBaseView

@property (nonatomic, strong, readonly) UIButton *cameraButton;
@property (nonatomic, strong, readonly) PGLoginUserInfoTextField *nicknameTextField;
@property (nonatomic, strong, readonly) PGLoginUserInfoTextField *dateTextField;
@property (nonatomic, strong, readonly) PGLoginUserInfoTextField *sexTextField;
@property (nonatomic, strong, readonly) UIButton *nextButton;

@end
