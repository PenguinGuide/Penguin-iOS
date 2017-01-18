//
//  PGShareButton.m
//  Penguin
//
//  Created by Jing Dai on 18/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGShareButton.h"

@interface PGShareButton ()

@property (nonatomic, strong) NSString *image;
@property (nonatomic, strong) NSString *title;

@end

@implementation PGShareButton

- (void)setImage:(NSString *)image title:(NSString *)title
{
    self.image = image;
    self.title = title;
    
    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake((self.pg_width-30)/2, 0, 30, 30)];
    imageView.image = [UIImage imageNamed:image];
    
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, self.pg_height-20, self.pg_width, 14)];
    label.text = title;
    label.textColor = Theme.colorLightText;
    label.font = Theme.fontSmall;
    label.textAlignment = NSTextAlignmentCenter;
    
    [self addSubview:imageView];
    [self addSubview:label];
}

@end
