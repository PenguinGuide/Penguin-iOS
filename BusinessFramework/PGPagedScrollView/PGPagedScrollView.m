//
//  PGPagedScrollView.m
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGPagedScrollView.h"
#import "FXPageControl.h"

@interface UIColor (PGPagedScrollViewColor)

+ (UIColor *)colorWithHexString:(NSString *)hexString;

@end

@implementation UIColor (PGPagedScrollViewColor)

+ (UIColor *)colorWithHexString:(NSString *)hexString
{
    NSString *colorString = [[hexString stringByReplacingOccurrencesOfString:@"#" withString:@""] uppercaseString];
    CGFloat alpha, red, blue, green;
    switch ([colorString length]) {
        case 3: // #RGB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:1];
            green = [self colorComponentFrom:colorString start:1 length:1];
            blue  = [self colorComponentFrom:colorString start:2 length:1];
            break;
        case 4: // #ARGB
            alpha = [self colorComponentFrom:colorString start:0 length:1];
            red   = [self colorComponentFrom:colorString start:1 length:1];
            green = [self colorComponentFrom:colorString start:2 length:1];
            blue  = [self colorComponentFrom:colorString start:3 length:1];
            break;
        case 6: // #RRGGBB
            alpha = 1.0f;
            red   = [self colorComponentFrom:colorString start:0 length:2];
            green = [self colorComponentFrom:colorString start:2 length:2];
            blue  = [self colorComponentFrom:colorString start:4 length:2];
            break;
        case 8: // #AARRGGBB
            alpha = [self colorComponentFrom:colorString start:0 length:2];
            red   = [self colorComponentFrom:colorString start:2 length:2];
            green = [self colorComponentFrom:colorString start:4 length:2];
            blue  = [self colorComponentFrom:colorString start:6 length:2];
            break;
        default:
            return nil;
    }
    
    return [UIColor colorWithRed:red green:green blue:blue alpha:alpha];
}

+ (CGFloat)colorComponentFrom:(NSString *)string start:(NSUInteger)start length:(NSUInteger)length {
    NSString *substring = [string substringWithRange: NSMakeRange(start, length)];
    NSString *fullHex = length == 2 ? substring : [NSString stringWithFormat: @"%@%@", substring, substring];
    unsigned hexComponent;
    [[NSScanner scannerWithString:fullHex] scanHexInt:&hexComponent];
    return hexComponent / 255.0;
}

@end

@interface PGPagedScrollView () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *pagedScrollView;
@property (nonatomic, strong) FXPageControl *pageControl;
@property (nonatomic, strong) NSArray *banners;
@property (nonatomic) PGPagedScrollViewImageFillMode fillMode;
@property (nonatomic) PGPagedScrollViewIconMode iconMode;

@end

@implementation PGPagedScrollView

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self addSubview:self.pagedScrollView];
        [self addSubview:self.pageControl];
    }
    
    return self;
}

- (id)initWithFrame:(CGRect)frame imageFillMode:(PGPagedScrollViewImageFillMode)fillMode iconMode:(PGPagedScrollViewIconMode)iconMode
{
    if (self = [super initWithFrame:frame]) {
        self.fillMode = fillMode;
        self.iconMode = iconMode;
        
        [self addSubview:self.pagedScrollView];
        [self addSubview:self.pageControl];
    }
    
    return self;
}

- (void)reloadData
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagesForScrollView)]) {
        self.banners = [self.delegate imagesForScrollView];
        if (self.banners.count > 0) {
            self.pagedScrollView.contentSize = CGSizeMake(self.frame.size.width*self.banners.count, self.pagedScrollView.frame.size.height);
            for (UIView *subview in self.pagedScrollView.subviews) {
                [subview removeFromSuperview];
            }
            for (int i = 0; i < self.banners.count; i++) {
                NSString *imageName = self.banners[i];
                if ([imageName containsString:@".gif"]) {
                    NSString *fileName = [imageName stringByReplacingOccurrencesOfString:@".gif" withString:@""];
                    NSString *gifPath = [[NSBundle mainBundle] pathForResource:fileName ofType:@"gif"];
                    FLAnimatedImage *gifImage = [FLAnimatedImage animatedImageWithGIFData:[NSData dataWithContentsOfFile:gifPath]];
                    FLAnimatedImageView *gifImageView = [[FLAnimatedImageView alloc] init];
                    gifImageView.animatedImage = gifImage;
                    gifImageView.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height-15-30);
                    [self.pagedScrollView addSubview:gifImageView];
                } else {
                    UIImage *image = [UIImage imageNamed:imageName];
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.pagedScrollView.frame.size.height)];
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.image = image;
                    [self.pagedScrollView addSubview:imageView];
                }
            }
            _pageControl.numberOfPages = self.banners.count;
            _pageControl.currentPage = 0;
        }
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger prePage = self.pageControl.currentPage;
    
    CGRect visibleBounds = self.pagedScrollView.bounds;
    NSInteger currentPage = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    
    if (currentPage < 0) {
        currentPage = 0;
    }
    if (currentPage > self.banners.count-1) {
        currentPage = self.banners.count-1;
    }
    if (currentPage != prePage) {
        [self.pageControl setCurrentPage:currentPage];
    }
}

#pragma mark - <Setters && Getters>

- (UIScrollView *)pagedScrollView
{
    if (!_pagedScrollView) {
        if (self.fillMode == PGPagedScrollViewImageFillModeFit) {
            _pagedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height-15-8)];
        } else {
            _pagedScrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
        }
        _pagedScrollView.showsVerticalScrollIndicator = NO;
        _pagedScrollView.showsHorizontalScrollIndicator = NO;
        _pagedScrollView.pagingEnabled = YES;
        _pagedScrollView.delegate = self;
    }
    return _pagedScrollView;
}

- (UIPageControl *)pageControl
{
    if (!_pageControl) {
        _pageControl = [[FXPageControl alloc] initWithFrame:CGRectMake(0, self.frame.size.height-25, self.frame.size.width, 15)];
        _pageControl.userInteractionEnabled = NO;
        _pageControl.backgroundColor = [UIColor clearColor];
        _pageControl.dotSize = 8.f;
        _pageControl.selectedDotSize = 14.f;
        _pageControl.dotSpacing = 15.f;
        _pageControl.numberOfPages = 0;
        _pageControl.currentPage = 0;
        _pageControl.dotColor = [UIColor colorWithHexString:@"dbdbdb"];
        if (self.iconMode == PGPagedScrollViewIconModeLight) {
            _pageControl.selectedDotImage = [UIImage imageNamed:@"paged_control_icon_light"];
        } else {
            _pageControl.selectedDotImage = [UIImage imageNamed:@"paged_control_icon"];
        }
    }
    return _pageControl;
}

@end
