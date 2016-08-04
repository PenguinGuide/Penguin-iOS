//
//  PGAlertController.m
//  Penguin
//
//  Created by Jing Dai on 8/2/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGAlertController.h"

@interface UIImage (PGAlertController)

+ (UIImage *)imageWithColor:(UIColor *)color;

@end

@implementation UIImage (PGAlertController)

+ (UIImage *)imageWithColor:(UIColor *)color
{
    UIGraphicsBeginImageContext(CGSizeMake(1.f, 1.f));
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    CGContextSetFillColorWithColor(context, color.CGColor);
    CGContextFillRect(context, CGRectMake(0, 0, 1.f, 1.f));
    
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end

/****************** PGAlertAction ******************/

@implementation PGAlertActionStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightLight];
        self.color = [UIColor colorWithRed:51.f/256.f green:51.f/256.f blue:51.f/256.f alpha:1.f];
        self.highlightedColor = [UIColor colorWithRed:239.f/256.f green:237.f/256.f blue:231.f/256.f alpha:1.f];
    }
    return self;
}

@end

@interface PGAlertAction ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) PGAlertActionStyle *style;
@property (nonatomic, copy) PGAlertActionHandler handler;

@end

@implementation PGAlertAction

+ (PGAlertAction *)actionWithTitle:(NSString *)title style:(void (^)(PGAlertActionStyle *style))styleBlock hander:(PGAlertActionHandler)handler
{
    PGAlertActionStyle *style = [[PGAlertActionStyle alloc] init];
    if (styleBlock) {
        styleBlock(style);
    }
    
    if (style.type == PGAlertActionTypeCancel) {
        style.color = [UIColor colorWithRed:239.f/256.f green:103.f/256.f blue:51.f/256.f alpha:1.f];
    } else if (style.type == PGAlertActionTypeDestructive) {
        style.color = [UIColor colorWithRed:239.f/256.f green:103.f/256.f blue:51.f/256.f alpha:1.f];
    }
    
    PGAlertAction *alertAction = [[PGAlertAction alloc] init];
    alertAction.title = title;
    alertAction.style = style;
    alertAction.handler = [handler copy];
    
    return alertAction;
}

@end

/****************** PGAlertController ******************/

@implementation PGAlertStyle

- (instancetype)init
{
    self = [super init];
    if (self) {
        self.alertType = PGAlertTypeAlert;
        self.titleFont = [UIFont systemFontOfSize:14.f weight:UIFontWeightBold];
        self.messageFont = [UIFont systemFontOfSize:14.f weight:UIFontWeightThin];
        self.backgroundColor = [UIColor whiteColor];
        self.borderColor = [UIColor blackColor];
        self.cornerRadius = 4.f;
    }
    return self;
}

@end

@interface PGAlertController ()

@property (nonatomic, strong) NSString *title;
@property (nonatomic, strong) NSString *message;
@property (nonatomic, strong) NSArray *actions;
@property (nonatomic, strong) PGAlertStyle *style;
@property (nonatomic, strong) UIView *alertView;
@property (nonatomic, strong) UIView *actionSheetView;

@end

@implementation PGAlertController

+ (PGAlertController *)alertControllerWithTitle:(NSString *)title message:(NSString *)message style:(void (^)(PGAlertStyle *))styleConfig
{
    PGAlertController *alertController = [[PGAlertController alloc] init];
    alertController.title = title;
    alertController.message = message;
    
    PGAlertStyle *style = [[PGAlertStyle alloc] init];
    if (styleConfig) {
        styleConfig(style);
    }
    alertController.style = style;
    
    alertController.modalPresentationStyle = UIModalPresentationOverCurrentContext;
    alertController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    alertController.view.backgroundColor = [UIColor colorWithWhite:0.f alpha:0.8f];
    
    return alertController;
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    if (self.actionSheetView) {
        __weak typeof(self) weakSelf = self;
        [UIView animateWithDuration:0.2
                              delay:0.f
                            options:UIViewAnimationOptionCurveLinear
                         animations:^{
                             weakSelf.actionSheetView.frame = CGRectMake(0, weakSelf.view.frame.size.height-self.actionSheetView.frame.size.height, self.actionSheetView.frame.size.width, self.actionSheetView.frame.size.height);
                         } completion:^(BOOL finished) {
                             
                         }];
    }
}

- (void)addActions:(NSArray *)actions
{
    self.actions = actions;
    
    if (self.title && self.title.length > 0) {
        if (self.style.alertType == PGAlertTypeAlert) {
            [self setupAlert];
        } else {
            [self setupActionSheet];
        }
    } else if (self.style.alertType == PGAlertTypeActionSheet) {
        [self setupActionSheet];
    }
}

- (void)setupAlert
{
    self.alertView = [[UIView alloc] init];
    self.alertView.backgroundColor = self.style.backgroundColor?self.style.backgroundColor:[UIColor whiteColor];
    if (self.style.cornerRadius > 0.f) {
        self.alertView.clipsToBounds = YES;
        self.alertView.layer.cornerRadius = self.style.cornerRadius;
    }
    CGFloat buttonsHeight = self.actions.count == 2 ? 44.f : 44.f * self.actions.count;
    CGFloat titleLabelHeight = 16.f;
    CGFloat messageLabelHeight = 0.f;
    if (self.message && self.message.length > 0) {
        CGSize messageSize = [self.message sizeWithAttributes:@{NSFontAttributeName:self.style.messageFont}];
        messageLabelHeight = messageSize.height+5;
    }
    
    CGFloat alertViewWidth = 275.f;
    
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 20, alertViewWidth, titleLabelHeight)];
    titleLabel.numberOfLines = 1;
    titleLabel.text = self.title;
    titleLabel.font = self.style.titleFont;
    titleLabel.textColor = [UIColor colorWithRed:51.f/256.f green:51.f/256.f blue:51.f/256.f alpha:1.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.alertView addSubview:titleLabel];
    
    if (messageLabelHeight > 0.f) {
        UILabel *messageLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height+10, alertViewWidth, messageLabelHeight)];
        messageLabel.numberOfLines = 0;
        messageLabel.text = self.message;
        messageLabel.font = self.style.messageFont;
        messageLabel.textColor = [UIColor colorWithRed:51.f/256.f green:51.f/256.f blue:51.f/256.f alpha:1.f];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [self.alertView addSubview:messageLabel];
    }
    
    CGFloat top = 20+titleLabelHeight+10+messageLabelHeight+20;
    if (self.actions.count == 1) {
        PGAlertAction *action = self.actions[0];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, top, alertViewWidth, 44)];
        button.tag = 0;
        [button setTitle:action.title forState:UIControlStateNormal];
        [button setTitleColor:action.style.color forState:UIControlStateNormal];
        [button setBackgroundImage:[UIImage imageWithColor:action.style.highlightedColor] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:action.style.font];
        [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.alertView addSubview:button];
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, top, alertViewWidth, 1/[UIScreen mainScreen].scale)];
        horizontalLine.backgroundColor = [UIColor colorWithRed:204.f/256.f green:204.f/256.f blue:204.f/256.f alpha:1.f];
        [self.alertView addSubview:horizontalLine];
        
    } else if (self.actions.count == 2) {
        for (int i = 0; i <self.actions.count; i++) {
            PGAlertAction *action = self.actions[i];
            
            UIButton *button = [[UIButton alloc] init];
            if (i == 0) {
                button.frame = CGRectMake(0, top, alertViewWidth/2, 44);
            } else {
                button.frame = CGRectMake(alertViewWidth/2, top, alertViewWidth/2, 44);
            }
            button.tag = i;
            [button setTitle:action.title forState:UIControlStateNormal];
            [button setTitleColor:action.style.color forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:action.style.highlightedColor] forState:UIControlStateHighlighted];
            [button.titleLabel setFont:action.style.font];
            [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:button];
            
            UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, top, alertViewWidth, 1/[UIScreen mainScreen].scale)];
            horizontalLine.backgroundColor = [UIColor colorWithRed:204.f/256.f green:204.f/256.f blue:204.f/256.f alpha:1.f];
            [self.alertView addSubview:horizontalLine];
            
            UIView *verticalLine = [[UIView alloc] initWithFrame:CGRectMake(alertViewWidth/2, top, 1/[UIScreen mainScreen].scale, 44)];
            verticalLine.backgroundColor = [UIColor colorWithRed:204.f/256.f green:204.f/256.f blue:204.f/256.f alpha:1.f];
            [self.alertView addSubview:verticalLine];
        }
    } else {
        for (int i = 0; i < self.actions.count; i++) {
            PGAlertAction *action = self.actions[i];
            
            UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, top, alertViewWidth, 44)];
            button.tag = i;
            [button setTitle:action.title forState:UIControlStateNormal];
            [button setTitleColor:action.style.color forState:UIControlStateNormal];
            [button setBackgroundImage:[UIImage imageWithColor:action.style.highlightedColor] forState:UIControlStateHighlighted];
            [button.titleLabel setFont:action.style.font];
            [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
            [self.alertView addSubview:button];
            
            UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, top, alertViewWidth, 1/[UIScreen mainScreen].scale)];
            horizontalLine.backgroundColor = [UIColor colorWithRed:204.f/256.f green:204.f/256.f blue:204.f/256.f alpha:1.f];
            [self.alertView addSubview:horizontalLine];
            
            top = top + 44.f;
        }
    }
    
    CGFloat alertViewHeight = 20+titleLabelHeight+10+messageLabelHeight+20+buttonsHeight;
    self.alertView.frame = CGRectMake((self.view.frame.size.width-alertViewWidth)/2, (self.view.frame.size.height-alertViewHeight)/2-alertViewHeight/2+50, alertViewWidth, alertViewHeight);
    
    [self.view addSubview:self.alertView];
}

- (void)setupActionSheet
{
    self.actionSheetView = [[UIView alloc] init];
    self.actionSheetView.backgroundColor = [UIColor whiteColor];
    
    CGFloat buttonsHeight = self.actions.count * 44.f;
    CGFloat titleLabelHeight = (self.title && self.title.length > 0) ? 16.f : 0.f;
    CGFloat messageLabelHeight = 0.f;
    if (self.message && self.message.length > 0) {
        CGSize messageSize = [self.message sizeWithAttributes:@{NSFontAttributeName:self.style.messageFont}];
        messageLabelHeight = messageSize.height+5;
    }
    
    CGFloat actionSheetViewWidth = self.view.frame.size.width;
    
    UILabel *titleLabel = [[UILabel alloc] init];
    if (self.title && self.title.length > 0) {
        if (self.message && self.message.length > 0) {
            titleLabel.frame = CGRectMake(0, 20, actionSheetViewWidth, titleLabelHeight);
        } else {
            titleLabel.frame = CGRectMake(0, 0, actionSheetViewWidth, titleLabelHeight+30);
        }
    } else {
        titleLabel.frame = CGRectMake(0, 0, actionSheetViewWidth, titleLabelHeight);
    }
    titleLabel.numberOfLines = 1;
    titleLabel.text = self.title;
    titleLabel.font = self.style.titleFont;
    titleLabel.textColor = [UIColor colorWithRed:51.f/256.f green:51.f/256.f blue:51.f/256.f alpha:1.f];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [self.actionSheetView addSubview:titleLabel];
    
    UILabel *messageLabel = [[UILabel alloc] init];
    if (messageLabelHeight > 0.f) {
        if (self.title && self.title.length > 0) {
            messageLabel.frame = CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height+10, actionSheetViewWidth, messageLabelHeight);
        } else {
            messageLabel.frame = CGRectMake(0, titleLabel.frame.origin.y+titleLabel.frame.size.height, actionSheetViewWidth, messageLabelHeight+30);
        }
        messageLabel.numberOfLines = 0;
        messageLabel.text = self.message;
        messageLabel.font = self.style.messageFont;
        messageLabel.textColor = [UIColor colorWithRed:51.f/256.f green:51.f/256.f blue:51.f/256.f alpha:1.f];
        messageLabel.textAlignment = NSTextAlignmentCenter;
        [self.actionSheetView addSubview:messageLabel];
    }
    
    CGFloat top = 0.f;
    if (self.title && self.title.length > 0) {
        if (self.message && self.message.length > 0) {
            top = messageLabel.frame.origin.y+messageLabel.frame.size.height+10;
        } else {
            top = titleLabel.frame.origin.y+titleLabel.frame.size.height;
        }
    } else {
        top = messageLabel.frame.origin.y+messageLabel.frame.size.height;
    }
    for (int i = 0; i < self.actions.count; i++) {
        PGAlertAction *action = self.actions[i];
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, top, actionSheetViewWidth, 44)];
        button.tag = i;
        [button setTitle:action.title forState:UIControlStateNormal];
        [button setTitleColor:action.style.color forState:UIControlStateNormal];
        [button setBackgroundColor:[UIColor whiteColor]];
        [button setBackgroundImage:[UIImage imageWithColor:action.style.highlightedColor] forState:UIControlStateHighlighted];
        [button.titleLabel setFont:action.style.font];
        [button addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self.actionSheetView addSubview:button];
        
        UIView *horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, top, actionSheetViewWidth, 1/[UIScreen mainScreen].scale)];
        horizontalLine.backgroundColor = [UIColor colorWithRed:204.f/256.f green:204.f/256.f blue:204.f/256.f alpha:1.f];
        [self.actionSheetView addSubview:horizontalLine];
        
        top = top + 44.f;
    }
    
    UIView *dimView = [[UIView alloc] initWithFrame:CGRectMake(0, top, actionSheetViewWidth, 10)];
    dimView.backgroundColor = [UIColor colorWithRed:204.f/256.f green:204.f/256.f blue:204.f/256.f alpha:1.f];
    [self.actionSheetView addSubview:dimView];
    
    top = top + 10.f;
    
    UIButton *cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, top, actionSheetViewWidth, 44.f)];
    cancelButton.tag = self.actions.count;
    [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
    [cancelButton setTitleColor:[UIColor colorWithRed:51.f/256.f green:51.f/256.f blue:51.f/256.f alpha:1.f] forState:UIControlStateNormal];
    [cancelButton setBackgroundColor:[UIColor whiteColor]];
    [cancelButton setBackgroundImage:[UIImage imageWithColor:[UIColor colorWithRed:239.f/256.f green:237.f/256.f blue:231.f/256.f alpha:1.f]] forState:UIControlStateHighlighted];
    [cancelButton.titleLabel setFont:[UIFont systemFontOfSize:14.f weight:UIFontWeightLight]];
    [cancelButton addTarget:self action:@selector(actionButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
    [self.actionSheetView addSubview:cancelButton];
    
    CGFloat actionSheetViewHeight = top+44;
    self.actionSheetView.frame = CGRectMake(0, self.view.frame.size.height, actionSheetViewWidth, actionSheetViewHeight);
    [self.view addSubview:self.actionSheetView];
}

- (void)actionButtonClicked:(id)sender
{
    UIButton *button = (id)sender;
    NSInteger tag = button.tag;
    
    if (self.actionSheetView) {
        if (tag < self.actions.count) {
            __block PGAlertAction *action = self.actions[tag];
            
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.2
                                  delay:0.f
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 weakSelf.actionSheetView.frame = CGRectMake(0, weakSelf.view.frame.size.height, self.actionSheetView.frame.size.width, self.actionSheetView.frame.size.height);
                             } completion:^(BOOL finished) {
                                 [weakSelf.actionSheetView removeFromSuperview];
                                 [weakSelf dismissViewControllerAnimated:YES completion:^{
                                     if (action) {
                                         action.handler();
                                     }
                                 }];
                             }];
        } else {
            __weak typeof(self) weakSelf = self;
            [UIView animateWithDuration:0.2
                                  delay:0.f
                                options:UIViewAnimationOptionCurveLinear
                             animations:^{
                                 weakSelf.actionSheetView.frame = CGRectMake(0, weakSelf.view.frame.size.height, self.actionSheetView.frame.size.width, self.actionSheetView.frame.size.height);
                             } completion:^(BOOL finished) {
                                 [weakSelf.actionSheetView removeFromSuperview];
                                 [weakSelf dismissViewControllerAnimated:YES completion:nil];
                             }];
        }
    } else {
        if (tag < self.actions.count) {
            __block PGAlertAction *action = self.actions[tag];
            [self dismissViewControllerAnimated:YES completion:^{
                if (action) {
                    action.handler();
                }
            }];
        }
    }
}

@end
