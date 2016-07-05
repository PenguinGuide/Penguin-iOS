//
//  PGBaseViewController.h
//  Penguin
//
//  Created by Jing Dai on 7/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAPIClient.h"

@interface PGBaseViewController : UIViewController

@property (nonatomic, strong, readonly) PGAPIClient *apiClient;

@end
