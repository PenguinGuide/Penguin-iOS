//
//  PGShareViewController.h
//  Penguin
//
//  Created by Jing Dai on 18/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewController.h"

@interface PGShareViewController : PGBaseViewController

- (id)initWithShareLink:(NSString *)shareLink text:(NSString *)text title:(NSString *)title image:(NSString *)image thumbnail:(NSString *)thumbnail;

@end
