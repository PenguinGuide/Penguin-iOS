//
//  PGSystemNotificationView.m
//  Penguin
//
//  Created by Kobe Dai on 07/02/2017.
//  Copyright © 2017 Xinglian. All rights reserved.
//

#import "PGSystemNotificationView.h"

@interface PGSystemNotificationView ()

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *horizontalLine;
@property (nonatomic, strong) UIButton *cancelButton;
@property (nonatomic, strong) UIButton *doneButton;

@end

@implementation PGSystemNotificationView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor whiteColor];
        self.clipsToBounds = YES;
        self.layer.cornerRadius = 8.f;
        
        [self addSubview:self.titleLabel];
        [self addSubview:self.descLabel];
        
        self.horizontalLine = [[UIView alloc] initWithFrame:CGRectMake(0, self.pg_height-50, self.pg_width, 1/[UIScreen mainScreen].scale)];
        self.horizontalLine.backgroundColor = [UIColor colorWithHexString:@"e1e1e1"];
        [self addSubview:self.horizontalLine];
        [self addSubview:self.cancelButton];
        [self addSubview:self.doneButton];
        
        UIImageView *topLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, 56, 44)];
        topLeftImageView.image = [UIImage imageNamed:@"pg_system_notification_top_left"];
        [self addSubview:topLeftImageView];
        
        UIImageView *topRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.pg_width-15-32, 10, 32, 34)];
        topRightImageView.image = [UIImage imageNamed:@"pg_system_notification_top_right"];
        [self addSubview:topRightImageView];
        
        UIImageView *bottomLeftImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 130, 22, 54)];
        bottomLeftImageView.image = [UIImage imageNamed:@"pg_system_notification_bottom_left"];
        [self addSubview:bottomLeftImageView];
        
        UIImageView *bottomRightImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.pg_width-53, 121, 53, 54)];
        bottomRightImageView.image = [UIImage imageNamed:@"pg_system_notification_bottom_right"];
        [self addSubview:bottomRightImageView];
    }
    
    return self;
}

#pragma mark - <Button Events>

- (void)cancelButtonClicked
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissSystemNotificationView)]) {
        [self.delegate dismissSystemNotificationView];
    }
}

- (void)doneButtonClicked
{
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    if (self.delegate && [self.delegate respondsToSelector:@selector(dismissSystemNotificationView)]) {
        [self.delegate dismissSystemNotificationView];
    }
}

#pragma mark - <Lazy Init>

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        NSString *titleStr = @"开启消息推送";
        
        NSMutableAttributedString *attrS = [[NSMutableAttributedString alloc] init];
        NSTextAttachment *imageAttachment = [[NSTextAttachment alloc] init];
        imageAttachment.image = [UIImage imageNamed:@"pg_system_notification_icon"];
        imageAttachment.bounds = CGRectMake(-10, -5, imageAttachment.image.size.width, imageAttachment.image.size.height);
        NSAttributedString *imageAttrS = [NSAttributedString attributedStringWithAttachment:imageAttachment];
        [attrS appendAttributedString:imageAttrS];
        
        NSMutableAttributedString *titleAttrS = [[NSMutableAttributedString alloc] initWithString:titleStr];
        [titleAttrS addAttribute:NSFontAttributeName value:Theme.fontMediumBold range:NSMakeRange(0, titleStr.length)];
        [titleAttrS addAttribute:NSForegroundColorAttributeName value:Theme.colorText range:NSMakeRange(0, titleStr.length)];
        [attrS appendAttributedString:titleAttrS];
        
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 43, self.pg_width, 20)];
        _titleLabel.textAlignment = NSTextAlignmentCenter;
        _titleLabel.attributedText = attrS;
    }
    return _titleLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(23, self.titleLabel.pg_bottom+30, self.pg_width-23*2, 70)];
        _descLabel.numberOfLines = 0;
        NSMutableParagraphStyle *paraStyle = [[NSParagraphStyle defaultParagraphStyle] mutableCopy];
        paraStyle.lineSpacing = 5.f;
        paraStyle.firstLineHeadIndent = 10.f;
        paraStyle.headIndent = 10.f;
        paraStyle.tailIndent = -15.f;
        NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:@"企鹅将会通知你最新的吃喝评测和来自全球的好货及餐厅选择"
                                                                    attributes:@{NSFontAttributeName:Theme.fontMediumBold,
                                                                                 NSForegroundColorAttributeName:Theme.colorText,
                                                                                 NSParagraphStyleAttributeName:paraStyle}];
        _descLabel.attributedText = attrS;
    }
    return _descLabel;
}

- (UIButton *)cancelButton
{
    if (!_cancelButton) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(0, self.horizontalLine.pg_bottom, self.pg_width/2, self.pg_height-self.horizontalLine.pg_bottom)];
        [_cancelButton.titleLabel setFont:Theme.fontMediumBold];
        [_cancelButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [_cancelButton setTitle:@"以后再说" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

- (UIButton *)doneButton
{
    if (!_doneButton) {
        _doneButton = [[UIButton alloc] initWithFrame:CGRectMake(self.pg_width/2, self.horizontalLine.pg_bottom, self.pg_width/2, self.pg_height-self.horizontalLine.pg_bottom)];
        [_doneButton.titleLabel setFont:Theme.fontMediumBold];
        [_doneButton setTitleColor:Theme.colorExtraHighlight forState:UIControlStateNormal];
        [_doneButton setTitle:@"立即开启" forState:UIControlStateNormal];
        [_doneButton addTarget:self action:@selector(doneButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _doneButton;
}

@end
