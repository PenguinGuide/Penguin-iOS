//
//  PGSegmentedControl.m
//  Penguin
//
//  Created by Jing Dai on 24/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGSegmentedControl.h"

@interface PGSegmentedScrollView : UIScrollView

@end

@implementation PGSegmentedScrollView

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    if (!self.dragging) {
        [self.nextResponder touchesEnded:touches withEvent:event];
    } else {
        [super touchesEnded:touches withEvent:event];
    }
}

@end

@interface PGSegmentedControl () <UIScrollViewDelegate>

@property (nonatomic, strong) PGSegmentedControlConfig *config;

@property (nonatomic, strong) PGSegmentedScrollView *scrollView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSMutableArray *labels;

@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, strong) NSArray *segmentWidthsArray;
@property (nonatomic, strong) NSArray *segmentHeightsArray;
@property (nonatomic, assign) CGFloat segmentControlWidth;

@property (nonatomic, assign) BOOL scrollToLeft;

@end

@implementation PGSegmentedControl

- (id)initWithConfig:(PGSegmentedControlConfig *)config
{
    if (self = [super init]) {
        self.config = config;
        
        [self initSegmentControl];
    }
    
    return self;
}

- (void)reload:(PGSegmentedControlConfig *)config
{
    self.config = config;
    
    [self setNeedsLayout];  // call layoutSubviews，layoutSubviews方便数据计算
    [self setNeedsDisplay]; // call drawRect，drawRect方便视图重绘
}

- (void)scrollToPage:(NSInteger)page
{
    if (self.selectedSegmentIndex != page) {
        if (self.selectedSegmentIndex > page) {
            self.scrollToLeft = NO;
        } else {
            self.scrollToLeft = YES;
        }
        self.selectedSegmentIndex = page;
        
        if (self.indexClicked) {
            self.indexClicked(self.selectedSegmentIndex);
        }
        
        [self setNeedsDisplay];
    }
}

- (void)initSegmentControl
{
    self.selectedSegmentIndex = 0;
    
    // scroll view
    self.scrollView = [[PGSegmentedScrollView alloc] init];
    self.scrollView.scrollsToTop = NO;
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.showsVerticalScrollIndicator = NO;
    [self addSubview:self.scrollView];
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    [self updateSegmentsLayout];
}

- (void)drawRect:(CGRect)rect
{
    // otherwise background will be clear
    [self.config.backgroundColor setFill];
    UIRectFill([self bounds]);
    
    // remove all sublayers to avoid drawing images over existing ones
    self.scrollView.layer.sublayers = nil;
    
    __weak typeof(self) weakself = self;
    [self.config.titles enumerateObjectsUsingBlock:^(id title, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize titleSize = [weakself titleSizeAtIndex:idx];
        CGFloat x = weakself.config.segmentMargin+weakself.config.segmentPadding*idx;
        for (int i = 0; i < weakself.segmentWidthsArray.count; i++) {
            if (i == idx) {
                break;
            }
            NSNumber *segmentWidth = weakself.segmentWidthsArray[i];
            x += [segmentWidth floatValue];
        }
        
        NSNumber *currentSegmentWidth = weakself.segmentWidthsArray[idx];
        
        CATextLayer *titleLayer = [CATextLayer layer];
        NSAttributedString *titleAttrStr = [weakself titleAttrStrAtIndex:idx];
        titleLayer.frame = CGRectMake(x, (weakself.frame.size.height-titleAttrStr.size.height)/2, [currentSegmentWidth floatValue], titleAttrStr.size.height);
        titleLayer.string = [weakself titleAttrStrAtIndex:idx];
        titleLayer.alignmentMode = kCAAlignmentCenter;
        titleLayer.contentsScale = [[UIScreen mainScreen] scale];
        if ([UIDevice currentDevice].systemVersion.floatValue < 10.0 ) {
            titleLayer.truncationMode = kCATruncationEnd;
        }
        
        [weakself.scrollView.layer addSublayer:titleLayer];
    }];
    
    // add indicator view
    if (!self.indicatorView) {
        self.indicatorView = [[self.config.SelectedViewClass alloc] init];
        self.indicatorView.backgroundColor = [UIColor clearColor];
    }
    if (self.selectedSegmentIndex < self.segmentWidthsArray.count) {
        CGFloat totalX = 0.f;
        if (self.config.equalWidth) {
            NSNumber *segmentWidth = weakself.segmentWidthsArray[weakself.selectedSegmentIndex];
            totalX = self.config.segmentMargin+[segmentWidth floatValue]*(self.selectedSegmentIndex+1)+self.config.segmentPadding*self.selectedSegmentIndex;
        } else {
            for (int i = 0; i <= self.selectedSegmentIndex; i++) {
                NSNumber *segmentWidth = self.segmentWidthsArray[i];
                if (i == 0) {
                    totalX = self.config.segmentMargin+[segmentWidth floatValue];
                } else {
                    totalX = totalX + self.config.segmentPadding+[segmentWidth floatValue];
                }
            }
            
            if (self.scrollToLeft) {
                CGRect visibleRect = CGRectMake(totalX, 0, [self.segmentWidthsArray[self.selectedSegmentIndex] floatValue], [self.segmentHeightsArray[self.selectedSegmentIndex] floatValue]);
                // NOTE: IMPORTANT note to learn
                [self.scrollView scrollRectToVisible:visibleRect animated:YES];
            } else {
                CGRect visibleRect = CGRectMake(totalX-[self.segmentWidthsArray[self.selectedSegmentIndex] floatValue]-self.config.segmentPadding, 0, [self.segmentWidthsArray[self.selectedSegmentIndex] floatValue], [self.segmentHeightsArray[self.selectedSegmentIndex] floatValue]);
                // NOTE: IMPORTANT note to learn
                [self.scrollView scrollRectToVisible:visibleRect animated:YES];
            }
        }
        
        __weak typeof(self) weakself = self;
        __block CGSize currentTitleSize = [self titleSizeAtIndex:self.selectedSegmentIndex];
        [UIView animateWithDuration:0.2f
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             NSNumber *currentSegmentWidth = weakself.segmentWidthsArray[weakself.selectedSegmentIndex];
                             NSNumber *currentSegmentHeight = weakself.segmentHeightsArray[weakself.selectedSegmentIndex];
                             if (weakself.config.equalWidth) {
                                 CGFloat delta = ([currentSegmentWidth floatValue]-currentTitleSize.width)/2;
                                 weakself.indicatorView.frame = CGRectMake(totalX-delta-currentTitleSize.width-weakself.config.segmentPadding/2, (weakself.frame.size.height-[currentSegmentHeight floatValue])/2, currentTitleSize.width+weakself.config.segmentPadding, [currentSegmentHeight floatValue]);
                             } else {
                                 weakself.indicatorView.frame = CGRectMake(totalX-[currentSegmentWidth floatValue]-weakself.config.segmentPadding/2, (weakself.frame.size.height-[currentSegmentHeight floatValue])/2, [currentSegmentWidth floatValue]+weakself.config.segmentPadding, [currentSegmentHeight floatValue]);
                             }
                         } completion:nil];
    }
    if (!self.indicatorView.superview) {
        [self.scrollView addSubview:self.indicatorView];
    }
}

- (void)updateSegmentsLayout
{
    NSMutableArray *segmentWidthsArray = [NSMutableArray new];
    NSMutableArray *segmentHeightsArray = [NSMutableArray new];
    
    __weak typeof(self) weakself = self;
    self.segmentControlWidth = self.config.segmentMargin*2 + self.config.segmentPadding*(self.config.titles.count-1);
    [self.config.titles enumerateObjectsUsingBlock:^(id title, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize titleSize = [weakself titleSizeAtIndex:idx];
        if (weakself.config.equalWidth) {
            CGFloat titleWidth = (weakself.frame.size.width-weakself.segmentControlWidth)/weakself.config.titles.count;
            [segmentWidthsArray addObject:@(titleWidth)];
            [segmentHeightsArray addObject:@(titleSize.height)];
        } else {
            weakself.segmentControlWidth += titleSize.width;
            [segmentWidthsArray addObject:@(titleSize.width)];
            [segmentHeightsArray addObject:@(titleSize.height)];
        }
    }];
    self.segmentWidthsArray = [NSArray arrayWithArray:segmentWidthsArray];
    self.segmentHeightsArray = [NSArray arrayWithArray:segmentHeightsArray];
    
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    if (self.config.equalWidth) {
        self.scrollView.contentSize = CGSizeMake(self.frame.size.width, self.frame.size.height);
    } else {
        self.scrollView.contentSize = CGSizeMake(self.segmentControlWidth, self.frame.size.height);
    }
}

- (NSAttributedString *)titleAttrStrAtIndex:(NSInteger)index
{
    if (index < self.config.titles.count) {
        NSString *title = self.config.titles[index];
        NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:title
                                                                    attributes:@{NSFontAttributeName:self.config.textFont,
                                                                                 NSForegroundColorAttributeName:index==self.selectedSegmentIndex?self.config.selectedTextColor:self.config.textColor}];
        return attrS;
    }
    return nil;
}

- (CGSize)titleSizeAtIndex:(NSInteger)index
{
    if (index < self.config.titles.count) {
        NSString *title = self.config.titles[index];
        return [title sizeWithAttributes:@{NSFontAttributeName:self.config.textFont}];
    }
    return CGSizeZero;
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint location = [touch locationInView:self];
    
    CGFloat x = location.x + self.scrollView.contentOffset.x;
    NSInteger selectedSegmentIndex = self.selectedSegmentIndex;
    __block CGFloat totalX = 0;
    for (int i = 0; i < self.segmentWidthsArray.count; i++) {
        NSNumber *segmentWidth = self.segmentWidthsArray[i];
        CGFloat minX = totalX+self.config.segmentPadding/2;
        
        if (i == 0) {
            totalX = self.config.segmentMargin+[segmentWidth floatValue];
        } else {
            totalX = totalX+self.config.segmentPadding+[segmentWidth floatValue];
        }
        
        CGFloat maxX = totalX+self.config.segmentPadding/2;
        
        if (x >= minX && x <= maxX) {
            selectedSegmentIndex = i;
            break;
        }
    }
    
    if (selectedSegmentIndex != self.selectedSegmentIndex) {
        if (self.indexClicked) {
            self.indexClicked(selectedSegmentIndex);
        }
        self.selectedSegmentIndex = selectedSegmentIndex;
        [self.pagedController scrollToPage:self.selectedSegmentIndex];
        
        [self setNeedsDisplay];
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (self.scrollView.contentOffset.y != 0) {
        self.scrollView.contentOffset = CGPointMake(self.scrollView.contentOffset.x, 0);
    }
}

@end
