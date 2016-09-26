//
//  PGVideoPlayerSlider.h
//  Penguin
//
//  Created by Jing Dai on 24/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PGVideoPlayerSliderDelegate <NSObject>

- (void)playerSliderValueChanged;

@end

@interface PGVideoPlayerSlider : UISlider

@property (nonatomic, weak) id<PGVideoPlayerSliderDelegate> delegate;

@end
