//
//  PGVideoVolumnSlider.h
//  Penguin
//
//  Created by Jing Dai on 24/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PGVideoVolumeSlider : UIView

@property (nonatomic, assign, readonly) float value;

- (void)setValue:(float)value;

@end
