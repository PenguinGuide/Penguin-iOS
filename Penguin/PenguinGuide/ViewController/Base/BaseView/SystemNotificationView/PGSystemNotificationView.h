//
//  PGSystemNotificationView.h
//  Penguin
//
//  Created by Kobe Dai on 07/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGSystemNotificationViewDelegate <NSObject>

- (void)dismissSystemNotificationView;

@end

@interface PGSystemNotificationView : UIView

@property (nonatomic, weak) id<PGSystemNotificationViewDelegate> delegate;

@end
