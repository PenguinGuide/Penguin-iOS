//
//  PGPwdLoginView.h
//  Penguin
//
//  Created by Jing Dai on 12/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGLoginDelegate.h"
#import "PGLoginTextField.h"

@interface PGPwdLoginView : UIView

@property (nonatomic, weak) id<PGLoginDelegate> delegate;
@property (nonatomic, strong) PGLoginTextField *phoneTextField;
@property (nonatomic, strong) PGLoginTextField *pwdTextField;

@end
