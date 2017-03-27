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
@property (nonatomic, strong) UILabel *pageLabel;
@property (nonatomic, strong) NSMutableArray *banners;
@property (nonatomic, strong) NSMutableArray *fixedBanners;
@property (nonatomic) PGPagedScrollViewImageFillMode fillMode;
@property (nonatomic) PGPagedScrollViewIconMode iconMode;
@property (nonatomic, assign) NSInteger currentPage;
@property (nonatomic, assign) NSInteger currentIndex;
@property (nonatomic, assign) BOOL circularMode;

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
        if (iconMode == PGPagedScrollViewIconModeLabel) {
            [self addSubview:self.pageLabel];
        } else {
            [self addSubview:self.pageControl];
        }
    }
    
    return self;
}

- (void)updateLabelFrame:(CGRect)frame
{
    self.pageLabel.frame = frame;
}

- (void)reloadData
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(imagesForScrollView)]) {
        NSArray *fixedBanners = [self.delegate imagesForScrollView];
        
        if (fixedBanners.count <= 1) {
            self.pageControl.hidden = YES;
        } else {
            self.pageControl.hidden = NO;
        }
        
        if (fixedBanners.count > 0) {
            self.banners = [NSMutableArray arrayWithArray:fixedBanners];
            if (fixedBanners.count > 1) {
                self.circularMode = YES;
                self.currentPage = 1;
                
                [self.banners insertObject:fixedBanners.lastObject atIndex:0];
                [self.banners addObject:fixedBanners.firstObject];
            } else {
                self.circularMode = NO;
            }
            
            self.currentIndex = 0;
            
            self.pagedScrollView.contentSize = CGSizeMake(self.frame.size.width*self.banners.count, self.pagedScrollView.frame.size.height);
            for (UIView *subview in self.pagedScrollView.subviews) {
                for (UIGestureRecognizer *gesture in subview.gestureRecognizers) {
                    [subview removeGestureRecognizer:gesture];
                }
                [subview removeFromSuperview];
            }
            for (int i = 0; i < self.banners.count; i++) {
                NSString *imageName = self.banners[i];
                if ([imageName containsString:@".gif"]) {
                    FLAnimatedImageView *gifImageView = [[FLAnimatedImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.frame.size.height-15-30)];
                    gifImageView.backgroundColor = [UIColor colorWithRed:248.f/256.f green:248.f/256.f blue:248.f/256.f alpha:1.f];
                    gifImageView.clipsToBounds = YES;
                    [gifImageView setWithImageURL:imageName placeholder:nil completion:nil];
                    [self.pagedScrollView addSubview:gifImageView];
                    
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)];
                    gifImageView.userInteractionEnabled = YES;
                    gifImageView.tag = i;
                    [gifImageView addGestureRecognizer:tapGesture];
                } else {
                    UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(i*self.frame.size.width, 0, self.frame.size.width, self.pagedScrollView.frame.size.height)];
                    imageView.backgroundColor = [UIColor colorWithRed:248.f/256.f green:248.f/256.f blue:248.f/256.f alpha:1.f];
                    imageView.contentMode = UIViewContentModeScaleAspectFill;
                    imageView.clipsToBounds = YES;
                    [imageView setWithImageURL:imageName placeholder:nil completion:nil];
                    [self.pagedScrollView addSubview:imageView];
                    
                    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)];
                    imageView.userInteractionEnabled = YES;
                    imageView.tag = i;
                    [imageView addGestureRecognizer:tapGesture];
                }
            }
            _pageControl.numberOfPages = fixedBanners.count;
            _pageControl.currentPage = self.currentIndex;
            
            [self.pagedScrollView setContentOffset:CGPointMake(self.currentPage*self.frame.size.width, 0) animated:NO];
        }
    } else if (self.delegate && [self.delegate respondsToSelector:@selector(viewsForScrollView)]) {
        self.circularMode = NO;
        NSArray *banners = [self.delegate viewsForScrollView];
        if (banners.count <= 1) {
            if (self.iconMode == PGPagedScrollViewIconModeLabel) {
                self.pageLabel.hidden = YES;
            } else {
                self.pageControl.hidden = YES;
            }
        } else {
            if (self.iconMode == PGPagedScrollViewIconModeLabel) {
                self.pageLabel.hidden = NO;
            } else {
                self.pageControl.hidden = NO;
            }
            self.currentPage = 1;
        }
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
                
                UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageViewDidTapped:)];
                view.userInteractionEnabled = YES;
                view.tag = i;
                [view addGestureRecognizer:tapGesture];
            }
            if (self.iconMode == PGPagedScrollViewIconModeLabel) {
                NSString *currentPageStr = [NSString stringWithFormat:@"%@", @(self.currentPage)];
                NSString *totalPagesStr = [NSString stringWithFormat:@"%@", @(banners.count)];
                NSString *countStr = [NSString stringWithFormat:@"%@/%@", currentPageStr, totalPagesStr];
                NSMutableAttributedString *countAttrStr = [[NSMutableAttributedString alloc] initWithString:countStr];
                [countAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.f weight:UIFontWeightBold] range:NSMakeRange(0, currentPageStr.length)];
                [countAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f weight:UIFontWeightBold] range:NSMakeRange(currentPageStr.length, 1+totalPagesStr.length)];
                self.pageLabel.attributedText = countAttrStr;
            } else {
                _pageControl.numberOfPages = self.banners.count;
                _pageControl.currentPage = self.currentPage;
            }
        }
    }
}

- (void)scrollToNextPage
{
    if (self.circularMode) {
        NSInteger currentIndex = self.currentPage+1;
        [self.pagedScrollView setContentOffset:CGPointMake(self.pagedScrollView.frame.size.width*(currentIndex+1), self.pagedScrollView.contentOffset.y) animated:YES];
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    NSInteger prePage;
    if (self.iconMode == PGPagedScrollViewIconModeLabel) {
        prePage = self.currentPage;
    } else {
        prePage = self.pageControl.currentPage;
    }
    
    CGRect visibleBounds = self.pagedScrollView.bounds;
    NSInteger currentPage = (NSInteger)(floorf(CGRectGetMidX(visibleBounds) / CGRectGetWidth(visibleBounds)));
    
    if (self.circularMode) {
        self.currentIndex = currentPage;
        
        if (currentPage == 0) {
            currentPage = self.banners.count-2;
        } else if (currentPage == self.banners.count-1) {
            currentPage = 0;
        } else {
            currentPage = currentPage - 1;
        }
    }
    
    if (currentPage < 0) {
        currentPage = 0;
    }
    if (currentPage > self.banners.count-1) {
        currentPage = self.banners.count-1;
    }
    if (currentPage != prePage) {
        if (self.iconMode == PGPagedScrollViewIconModeLabel) {
            NSString *currentPageStr = [NSString stringWithFormat:@"%@", @(currentPage+1)];
            NSString *totalPagesStr = [NSString stringWithFormat:@"%@", @(self.banners.count)];
            NSString *countStr = [NSString stringWithFormat:@"%@/%@", currentPageStr, totalPagesStr];
            NSMutableAttributedString *countAttrStr = [[NSMutableAttributedString alloc] initWithString:countStr];
            [countAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:16.f weight:UIFontWeightBold] range:NSMakeRange(0, currentPageStr.length)];
            [countAttrStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12.f weight:UIFontWeightBold] range:NSMakeRange(currentPageStr.length, 1+totalPagesStr.length)];
            self.pageLabel.attributedText = countAttrStr;
        } else {
            [self.pageControl setCurrentPage:currentPage];
        }
    }
    
    self.currentPage = currentPage;
}

// scrollToNextPage will not call this delegate method
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    if (self.circularMode) {
        if (self.currentIndex == 0) {
            [scrollView setContentOffset:CGPointMake((self.banners.count-2)*self.frame.size.width, 0) animated:NO];
        } else if (self.currentIndex == self.banners.count-1) {
            [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        }
        self.currentIndex = self.currentPage;
    }
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    if (self.circularMode) {
        if (self.currentIndex == 0) {
            [scrollView setContentOffset:CGPointMake((self.banners.count-2)*self.frame.size.width, 0) animated:NO];
        } else if (self.currentIndex == self.banners.count-1) {
            [scrollView setContentOffset:CGPointMake(self.frame.size.width, 0) animated:NO];
        }
        self.currentIndex = self.currentPage;
    }
}

- (void)imageViewDidTapped:(UIGestureRecognizer *)recognizer
{
    UIView *tappedView = [recognizer view];
    if (tappedView) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imageViewDidSelect:)]) {
            if (self.circularMode) {
                [self.delegate imageViewDidSelect:tappedView.tag-1];
            } else {
                [self.delegate imageViewDidSelect:tappedView.tag];
            }
        }
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
        } else if (self.iconMode == PGPagedScrollViewIconModeDark) {
            _pageControl.dotSize = 6.f;
            _pageControl.selectedDotSize = 6.f;
            _pageControl.selectedDotColor = [UIColor colorWithHexString:@"8B8B8B"];
            _pageControl.dotColor = [UIColor colorWithHexString:@"F1F1F1"];
        } else {
            _pageControl.dotSize = 6.f;
            _pageControl.selectedDotSize = 6.f;
            _pageControl.selectedDotColor = [UIColor whiteColor];
            _pageControl.dotColor = [UIColor colorWithHexString:@"8B8B8B"];
        }
    }
    return _pageControl;
}

- (UILabel *)pageLabel
{
    if (!_pageLabel) {
        _pageLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.frame.size.width-10-40, self.frame.size.height-10-30, 40, 30)];
        _pageLabel.backgroundColor = [UIColor colorWithWhite:1.f alpha:0.8f];
        _pageLabel.textColor = [UIColor blackColor];
        _pageLabel.textAlignment = NSTextAlignmentCenter;
        
        CAShapeLayer *maskLayer = [CAShapeLayer layer];
        maskLayer.frame = CGRectMake(0, 0, 40, 30);
        
        UIBezierPath *bezierPath = [UIBezierPath bezierPathWithRoundedRect:CGRectMake(0, 0, 40, 30) cornerRadius:4.f];
        maskLayer.path = bezierPath.CGPath;
        _pageLabel.layer.mask = maskLayer;
    }
    return _pageLabel;
}

@end
