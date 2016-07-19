//
//  PGBaseViewController.h
//  Penguin
//
//  Created by Jing Dai on 7/5/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGAPIClient.h"
#import "FBKVOController.h"

@interface PGBaseViewController : UIViewController

@property (nonatomic, strong, readonly) PGAPIClient *apiClient;
@property (nonatomic, strong, readonly) FBKVOController *KVOController;

- (void)observe:(id)object keyPath:(NSString *)keyPath block:(void(^)(id changedObject))block;
- (void)unobserve;

- (void)backButtonClicked;

@end
