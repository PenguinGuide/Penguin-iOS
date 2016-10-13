//
//  PGLoginDelegate.h
//  Penguin
//
//  Created by Jing Dai on 12/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol PGLoginDelegate <NSObject>

@optional

- (void)loginButtonClicked:(UIView *)view;
- (void)forgotPwdButtonClicked;

@end
