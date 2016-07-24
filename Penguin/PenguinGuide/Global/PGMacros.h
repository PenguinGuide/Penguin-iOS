//
//  PGMacros.h
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#ifndef PGMacros_h
#define PGMacros_h

#define PGGlobal [PGGlobalObject sharedInstance]

#define UISCREEN_WIDTH [[UIScreen mainScreen] bounds].size.width
#define UISCREEN_HEIGHT [[UIScreen mainScreen] bounds].size.height
#define SINGLE_LINE_WIDTH [UIScreen mainScreen].scale >= 2.0f ? 0.5f : 1.0f

#define DEVICE_IS_LESS_OR_EQUAL_TO_IPHONE_5 [[UIScreen mainScreen] bounds].size.width <= 320.f
#define DEVICE_IS_IPHONE_5 [[UIScreen mainScreen] bounds].size.height == 568.f
#define DEVICE_IS_IPHONE_4 [[UIScreen mainScreen] bounds].size.height < 568.f

#define PGWeakSelf(type) __weak typeof(type) weak##type = type;

#endif /* PGMacros_h */
