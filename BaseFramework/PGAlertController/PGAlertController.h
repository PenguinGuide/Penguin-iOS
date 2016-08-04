//
//  PGAlertController.h
//  Penguin
//
//  Created by Jing Dai on 8/2/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>

/****************** PGAlertAction ******************/

typedef NS_ENUM(NSInteger, PGAlertActionType) {
    PGAlertActionTypeDefault,
    PGAlertActionTypeCancel,
    PGAlertActionTypeDestructive
};

@interface PGAlertActionStyle : NSObject

@property (nonatomic, strong) UIFont *font;
@property (nonatomic, strong) UIColor *color;
@property (nonatomic, strong) UIColor *highlightedColor;
@property (nonatomic, assign) PGAlertActionType type;

@end

typedef void(^PGAlertActionHandler)();

@interface PGAlertAction : NSObject

+ (PGAlertAction *)actionWithTitle:(NSString *)title style:(void(^)(PGAlertActionStyle *style))styleBlock hander:(PGAlertActionHandler)handler;

@end

/****************** PGAlertController ******************/

typedef NS_ENUM(NSInteger, PGAlertType) {
    PGAlertTypeAlert,
    PGAlertTypeActionSheet
};

@interface PGAlertStyle : NSObject

@property (nonatomic, assign) PGAlertType alertType;
@property (nonatomic, strong) UIFont *titleFont;
@property (nonatomic, strong) UIFont *messageFont;
@property (nonatomic, strong) UIColor *backgroundColor;
@property (nonatomic, strong) UIColor *borderColor;
@property (nonatomic, assign) CGFloat cornerRadius;

@end

@class PGAlertStyle;

@interface PGAlertController : UIViewController

+ (PGAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message style:(void(^)(PGAlertStyle *style))styleConfig;

- (void)addActions:(NSArray *)actions;

@end
