//
//  PGLoginBaseViewController.h
//  Penguin
//
//  Created by Jing Dai on 12/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"
#import "PGLoginDelegate.h"

@interface PGLoginBaseViewController : PGBaseViewController <PGLoginDelegate, UITextFieldDelegate>

@property (nonatomic, strong) UIScrollView *loginScrollView;
@property (nonatomic, strong) UIImageView *logoImageView;

@property (nonatomic, strong) UIButton *backButton;
@property (nonatomic, strong) UIButton *closeButton;

@end
