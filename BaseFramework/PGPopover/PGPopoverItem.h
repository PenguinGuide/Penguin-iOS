//
//  PGPopoverItem.h
//  Penguin
//
//  Created by Jing Dai on 9/2/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGPopoverItem : NSObject

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *icon;
@property (nonatomic, strong) NSString *highlightIcon;
@property (nonatomic, assign) BOOL selected;

@end
