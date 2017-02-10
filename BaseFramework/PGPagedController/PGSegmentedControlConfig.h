//
//  PGSegmentedControlConfig.h
//  Penguin
//
//  Created by Jing Dai on 04/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGSegmentedControlConfig : NSObject

@property (nonatomic, strong) NSArray *titles;

@property (nonatomic, assign) CGFloat segmentHeight;

@property (nonatomic, assign) Class SelectedViewClass;

/**
 Control background color
 
 Default is white color
 */
@property (nonatomic, strong) UIColor *backgroundColor;

/**
 Label title text color
 
 Default is rgb(175, 189, 189)
 */
@property (nonatomic, strong) UIColor *textColor;

/**
 Label title selected text color
 
 Default is black color
 */
@property (nonatomic, strong) UIColor *selectedTextColor;

/**
 Label title font
 
 Default is system bold font with 16.f
 */
@property (nonatomic, strong) UIFont *textFont;

/**
 Left-most segment distance to left bounds, right-most segment distance to right bounds
 
 Default is 20.f
 */
@property (nonatomic, assign) CGFloat segmentMargin;

/**
 Gap distance for segments
 
 Default is 25.f
 */
@property (nonatomic, assign) CGFloat segmentPadding;

/**
 Boolean value indicates all segments have equal width
 
 Default is NO
 */
@property (nonatomic, assign) BOOL equalWidth;

@end
