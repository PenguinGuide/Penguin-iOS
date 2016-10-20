//
//  PGPwdSaveView.h
//  Penguin
//
//  Created by Jing Dai on 13/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGLoginDelegate.h"
#import "PGLoginTextField.h"

@interface PGPwdSaveView : UIView

@property (nonatomic, weak) id<PGLoginDelegate> delegate;

@property (nonatomic, strong) PGLoginTextField *newPwdTextField;
@property (nonatomic, strong) UIButton *saveButton;

@end
