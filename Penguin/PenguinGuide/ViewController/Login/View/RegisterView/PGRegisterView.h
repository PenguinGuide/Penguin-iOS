//
//  PGRegisterView.h
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGLoginBaseView.h"
#import "PGLoginPhoneTextField.h"
#import "PGSocialView.h"

@interface PGRegisterView : PGLoginBaseView

@property (nonatomic, strong, readonly) PGLoginPhoneTextField *phoneTextField;
@property (nonatomic, strong, readonly) PGSocialView *socialView;
@property (nonatomic, strong, readonly) UIButton *nextButton;

@end
