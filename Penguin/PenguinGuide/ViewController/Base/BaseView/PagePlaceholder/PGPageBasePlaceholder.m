//
//  PGPageBasePlaceholder.m
//  Penguin
//
//  Created by Kobe Dai on 22/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGPageBasePlaceholder.h"

@interface PGPageBasePlaceholder ()

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *desc;

@property (nonatomic, strong) UIImageView *placeholderImageView;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIImageView *footerImageView;

@end

@implementation PGPageBasePlaceholder

- (id)initWithImage:(NSString *)image desc:(NSString *)desc top:(CGFloat)top height:(CGFloat)height
{
    if (self = [super init]) {
        self.backgroundColor = [UIColor whiteColor];
        self.frame = CGRectMake(0, top, UISCREEN_WIDTH, height);
        
        self.image = image;
        self.desc = desc;
        
        [self addSubview:self.placeholderImageView];
        [self addSubview:self.descLabel];
        [self addSubview:self.footerImageView];
        
        if (self.desc && self.desc.length > 0) {
            self.descLabel.hidden = NO;
        } else {
            self.descLabel.hidden = YES;
        }
    }
    
    return self;
}

- (UIImageView *)placeholderImageView
{
    if (!_placeholderImageView) {
        UIImage *placeholderImage = [UIImage imageNamed:self.image];
        CGFloat width = UISCREEN_WIDTH-30*2;
        CGFloat height = width * placeholderImage.size.height/placeholderImage.size.width;
        _placeholderImageView = [[UIImageView alloc] initWithFrame:CGRectMake(30, 50, width, height)];
        _placeholderImageView.image = placeholderImage;
        _placeholderImageView.clipsToBounds = YES;
        _placeholderImageView.contentMode = UIViewContentModeScaleAspectFill;
    }
    return _placeholderImageView;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, self.placeholderImageView.pg_bottom+30, self.pg_width, 20)];
        _descLabel.font = Theme.fontLargeBold;
        _descLabel.textColor = Theme.colorLightText;
        _descLabel.textAlignment = NSTextAlignmentCenter;
        _descLabel.text = self.desc;
    }
    return _descLabel;
}

- (UIImageView *)footerImageView
{
    if (!_footerImageView) {
        _footerImageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.pg_width-98)/2, self.pg_height-30-42, 98, 42)];
        _footerImageView.image = [UIImage imageNamed:@"pg_collection_view_footer_view"];
        [self addSubview:_footerImageView];
    }
    return _footerImageView;
}

@end
