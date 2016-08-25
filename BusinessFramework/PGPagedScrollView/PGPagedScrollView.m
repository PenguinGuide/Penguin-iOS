//
//  PGPagedScrollView.m
//  Penguin
//
//  Created by Jing Dai on 7/6/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGPagedScrollView.h"
#import "FXPageControl.h"

#import "FLAnimatedImageView+PGAnimatedImageView.h"
#import "UIImageView+PGImageView.h"

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
@property (nonatomic, strong) NSMutableArray *banners;
@property (nonatomic) PGPagedScrollViewImageFillMode fillMode;
@property (nonatomic) PGPagedScrollViewIconMode iconMode;
@property (nonatomic, assign) NSInteger currentPage;

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
        NSArray *fixedBanners = [self.delegate imagesForScrollView];
        
        if (fixedBanners.count > 0) {
            self.banners = [NSMutableArray arrayWithArray:fixedBanners];
//            [self.banners insertObject:fixedBanners.firstObject atIndex:0];
//            [self.banners addObject:fixedBanners.lastObject];
            
            self.pagedScrollView.contentSize = CGSizeMake(self.frame.size.width*fixedBanners.count, self.pagedScrollView.frame.size.height);
            for (UIView *subview in self.pagedScrollView.subviews) {
                [subview removeFromSuperview];
            }
            for (int i = 0; i < fixedBanners.count; i++) {
                NSString *imageName = fixedBanners[i];
                if ([imageName containsString:@".gif"]) {
                    FLAnimatedImageView *gifImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height-15-30)];
                    gifImageView.backgroundColor = [UIColor colorWithHexString:@"454545"];
                    [gifImageView setWithImageURL:imageName placeholder:nil completion:nil];
                    [self.pagedScrollView addSubview:gifImageView];
                } else {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.pagedScrollView.frame.size.height)];
                    imageView.backgroundColor = [UIColor colorWithHexString:@"454545"];
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    [imageView setWithImageURL:imageName placeholder:nil completion:nil];
                    [self.pagedScrollView addSubview:imageView];
                }
            }
            _pageControl.numberOfPages = fixedBanners.count;
            _pageControl.currentPage = self.currentPage;
        }
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(viewsForScrollView)]) {
        NSArray *banners = [self.delegate viewsForScrollView];
        if (banners.count > 0) {
            self.banners = [NSArray arrayWithArray:banners];
            self.pagedScrollView.contentSize = CGSizeMake(self.frame.size.width*self.banners.count, self.pagedScrollView.frame.size.height);
            for (UIView *subview in self.pagedScrollView.subviews) {
                [subview removeFromSuperview];
            }
            for (int i = 0; i < self.banners.count; i++) {
                UIView *view = self.banners[i];
                view.frame = CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.pagedScrollView.frame.size.height);
                [self.pagedScrollView addSubview:view];
            }
            _pageControl.numberOfPages = self.banners.count;
            _pageControl.currentPage = self.currentPage;
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
    
    self.currentPage = currentPage;
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
        _pageControl.dotSpacing = 15.f;
        _pageControl.numberOfPages = 0;
        _pageControl.currentPage = 0;
        
        if (self.iconMode == PGPagedScrollViewIconModeImageLight) {
            _pageControl.selectedDotImage = [UIImage imageNamed:@"paged_control_icon_light"];
            _pageControl.dotSize = 8.f;
            _pageControl.selectedDotSize = 14.f;
            _pageControl.dotColor = [UIColor colorWithHexString:@"dbdbdb"];
        } else if (self.iconMode == PGPagedScrollViewIconModeImageDark) {
            _pageControl.selectedDotImage = [UIImage imageNamed:@"paged_control_icon"];
            _pageControl.dotSize = 8.f;
            _pageControl.selectedDotSize = 14.f;
            _pageControl.dotColor = [UIColor colorWithHexString:@"dbdbdb"];
        } else if (self.iconMode == PGPagedScrollViewIconModeLight) {
            _pageControl.dotSize = 6.f;
            _pageControl.selectedDotSize = 6.f;
            _pageControl.selectedDotColor = [UIColor colorWithHexString:@"F1F1F1"];
            _pageControl.dotColor = [UIColor colorWithHexString:@"8B8B8B"];
        } else {
            _pageControl.dotSize = 6.f;
            _pageControl.selectedDotSize = 6.f;
            _pageControl.selectedDotColor = [UIColor whiteColor];
            _pageControl.dotColor = [UIColor colorWithHexString:@"8B8B8B"];
        }
    }
    return _pageControl;
}

@end
