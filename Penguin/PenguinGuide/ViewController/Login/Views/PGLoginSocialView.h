//
//  PGLoginSocialView.h
//  Penguin
//
//  Created by Jing Dai on 12/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGLoginDelegate.h"

@interface PGLoginSocialView : UIView

@property (nonatomic, weak) id<PGLoginDelegate> delegate;
@property (nonatomic, strong) UILabel *socialLabel;

@end