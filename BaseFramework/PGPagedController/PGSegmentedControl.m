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

@property (nonatomic, strong) PGSegmentedScrollView *scrollView;
@property (nonatomic, strong) UIView *indicatorView;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, assign) NSInteger currentPage;

@property (nonatomic, assign) NSInteger selectedSegmentIndex;
@property (nonatomic, strong) NSArray *segmentWidthsArray;
@property (nonatomic, assign) CGFloat segmentControlWidth;

@end

@implementation PGSegmentedControl

- (id)initWithSegmentTitles:(NSArray *)segmentTitles
{
    if (self = [super init]) {
        self.segmentTitles = segmentTitles;

        [self initSegmentControl];
    }
    return self;
}

- (void)reloadSegmentTitles:(NSArray *)segmentTitles
{
    self.segmentTitles = segmentTitles;
    
    [self setNeedsLayout];  // call layoutSubviews，layoutSubviews方便数据计算
    [self setNeedsDisplay]; // call drawRect，drawRect方便视图重绘
}

- (void)initSegmentControl
{
    // default attribute values
    self.backgroundColor = [UIColor whiteColor];
    
    self.textColor = [UIColor colorWithRed:175.f/256.f green:189.f/256.f blue:189.f/256.f alpha:1.f];
    self.selectedTextColor = [UIColor blackColor];
    self.textFont = [UIFont systemFontOfSize:16.f weight:UIFontWeightBold];
    
    self.segmentMargin = 15.f;
    self.segmentPadding = 15.f;
    
    self.equalWidth = NO;
    
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
    [self.backgroundColor setFill];
    UIRectFill([self bounds]);
    
    // remove all sublayers to avoid drawing images over existing ones
    self.scrollView.layer.sublayers = nil;
    
    __weak typeof(self) weakself = self;
    [self.segmentTitles enumerateObjectsUsingBlock:^(id title, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize titleSize = [weakself titleSizeAtIndex:idx];
        CGFloat x = weakself.segmentMargin+weakself.segmentPadding*idx;
        for (int i = 0; i < weakself.segmentWidthsArray.count; i++) {
            if (i == idx) {
                break;
            }
            NSNumber *segmentWidth = weakself.segmentWidthsArray[i];
            x += [segmentWidth floatValue];
        }
        
        CATextLayer *titleLayer = [CATextLayer layer];
        NSAttributedString *titleAttrStr = [weakself titleAttrStrAtIndex:idx];
        titleLayer.frame = CGRectMake(x, (weakself.frame.size.height-titleAttrStr.size.height)/2, titleSize.width, weakself.frame.size.height);
        titleLayer.string = [weakself titleAttrStrAtIndex:idx];
        titleLayer.alignmentMode = kCAAlignmentCenter;
        titleLayer.contentsScale = [[UIScreen mainScreen] scale];
        if ([UIDevice currentDevice].systemVersion.floatValue < 10.0 ) {
            titleLayer.truncationMode = kCATruncationEnd;
        }
        
        [weakself.scrollView.layer addSublayer:titleLayer];
    }];
}

- (void)updateSegmentsLayout
{
    NSMutableArray *segmentWidthsArray = [NSMutableArray new];
    
    __weak typeof(self) weakself = self;
    self.segmentControlWidth = self.segmentMargin*2 + self.segmentPadding*(self.segmentTitles.count-1);
    [self.segmentTitles enumerateObjectsUsingBlock:^(id title, NSUInteger idx, BOOL * _Nonnull stop) {
        CGSize titleSize = [weakself titleSizeAtIndex:idx];
        weakself.segmentControlWidth += titleSize.width;
        [segmentWidthsArray addObject:@(titleSize.width)];
    }];
    self.segmentWidthsArray = [NSArray arrayWithArray:segmentWidthsArray];
    
    self.scrollView.frame = CGRectMake(0, 0, self.frame.size.width, self.frame.size.height);
    self.scrollView.contentSize = CGSizeMake(self.segmentControlWidth, self.frame.size.height);
}

- (NSAttributedString *)titleAttrStrAtIndex:(NSInteger)index
{
    if (index < self.segmentTitles.count) {
        NSString *title = self.segmentTitles[index];
        NSAttributedString *attrS = [[NSAttributedString alloc] initWithString:title
                                                                    attributes:@{NSFontAttributeName:self.textFont,
                                                                                 NSForegroundColorAttributeName:index==self.selectedSegmentIndex?self.selectedTextColor:self.textColor}];
        return attrS;
    }
    return nil;
}

- (CGSize)titleSizeAtIndex:(NSInteger)index
{
    if (index < self.segmentTitles.count) {
        NSString *title = self.segmentTitles[index];
        return [title sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
    }
    return CGSizeZero;
}

- (void)reloadWithTitles:(NSArray *)titles Class:(__unsafe_unretained Class)SelectedViewClass
{
    for (UIView *subview in self.scrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    self.currentPage = 0;
    self.segmentTitles = titles;
    [self.labels removeAllObjects];
    
    if (titles.count > 0) {
        float totalWidth = self.margin;
        for (int i = 0; i < titles.count; i++) {
            float titleWidth;
            NSString *title = titles[i];
            if (self.equalWidth) {
                titleWidth = (self.frame.size.width-self.margin*2-(self.segmentTitles.count-1)*self.padding)/self.segmentTitles.count;
            } else {
                titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:self.textFont}].width+15;
            }
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(totalWidth, 0, titleWidth, self.frame.size.height)];
            label.textAlignment = NSTextAlignmentCenter;
            label.text = title;
            label.font = self.textFont;
            if (self.currentPage == i) {
                label.textColor = self.selectedTextColor;
            } else {
                label.textColor = self.textColor;
            }
            [self.scrollView addSubview:label];
            
            if (i != titles.count-1) {
                totalWidth = totalWidth+titleWidth+self.padding;
            } else {
                totalWidth = totalWidth+titleWidth;
            }
            
            [self.labels addObject:label];
        }
        totalWidth = totalWidth+self.margin;
        self.scrollView.contentSize = CGSizeMake(totalWidth, self.frame.size.height);
        
        if (self.labels.count > 0) {
            id selectedObject = [SelectedViewClass new];
            if ([selectedObject isKindOfClass:[UIView class]]) {
                self.indicatorView = (UIView *)selectedObject;
                self.indicatorView.backgroundColor = [UIColor clearColor];
                UILabel *firstLabel = self.labels.firstObject;
                if (firstLabel) {
                    NSString *firstTitle = titles[0];
                    CGSize titleSize = [firstTitle sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
                    if (self.equalWidth) {
                        self.indicatorView.frame = CGRectMake(firstLabel.frame.origin.x+(firstLabel.frame.size.width-(titleSize.width+20))/2, (firstLabel.frame.size.height-titleSize.height)/2, titleSize.width+20, titleSize.height);
                    } else {
                        self.indicatorView.frame = CGRectMake(firstLabel.frame.origin.x, (firstLabel.frame.size.height-titleSize.height)/2, firstLabel.frame.size.width, titleSize.height);
                    }
                    [self.scrollView addSubview:self.indicatorView];
                }
            }
        }
    }
}

- (void)scrollToPage:(NSInteger)page
{
    if (page < self.labels.count && self.currentPage != page) {
        UILabel *currentLabel = self.labels[self.currentPage];
        __block UILabel *nextLabel = self.labels[page];
        currentLabel.textColor = self.textColor;
        nextLabel.textColor = self.selectedTextColor;
        if (currentLabel.frame.origin.x > self.frame.size.width/2 && self.scrollView.contentSize.width > self.scrollView.frame.size.width) {
            CGPoint offset = self.scrollView.contentOffset;
            if (self.currentPage < page) {
                CGPoint nextOffset;
                if (page == self.labels.count-1) {
                    nextOffset = CGPointMake(offset.x+(nextLabel.frame.size.width+self.margin), offset.y);
                } else {
                    nextOffset = CGPointMake(offset.x+(nextLabel.frame.size.width+self.padding), offset.y);
                }
                if (nextOffset.x+self.scrollView.frame.size.width >= self.scrollView.contentSize.width) {
                    [self.scrollView setContentOffset:CGPointMake(self.scrollView.contentSize.width-self.scrollView.frame.size.width, offset.y) animated:YES];
                } else {
                    [self.scrollView setContentOffset:CGPointMake(offset.x+(nextLabel.frame.size.width+self.padding), offset.y) animated:YES];
                }
            } else {
                CGPoint preOffset = CGPointMake(offset.x-(nextLabel.frame.size.width+self.padding), offset.y);
                if (preOffset.x <= 0) {
                    [self.scrollView setContentOffset:CGPointMake(0, offset.y) animated:YES];
                } else {
                    [self.scrollView setContentOffset:CGPointMake(offset.x-(nextLabel.frame.size.width+self.padding), offset.y) animated:YES];
                }
            }
        } else {
            [self.scrollView setContentOffset:CGPointMake(0, self.scrollView.contentOffset.y) animated:YES];
        }
        
        self.currentPage = page;
        
        __weak typeof(self) weakSelf = self;
        __block CGSize titleSize = [self.segmentTitles[self.currentPage] sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
        [UIView animateWithDuration:0.2
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             weakSelf.indicatorView.frame = CGRectMake(nextLabel.frame.origin.x, (nextLabel.frame.size.height-titleSize.height)/2, nextLabel.frame.size.width, titleSize.height);
                         } completion:nil];
    }
}

- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    
    CGPoint location = [touch locationInView:self];
    CGPoint contentOffset = self.scrollView.contentOffset;
    CGFloat x = location.x+contentOffset.x;
    __block UILabel *selectedLabel;
    NSInteger selectedPage = self.currentPage;
    
    for (int i = 0; i < self.labels.count; i++) {
        UILabel *label = self.labels[i];
        if (label.frame.origin.x <= x && (label.frame.origin.x+label.frame.size.width) >= x) {
            selectedLabel = label;
            selectedPage = i;
            break;
        }
    }
    
    if (selectedLabel) {
        UILabel *preLabel = [self.labels objectAtIndex:self.currentPage];
        preLabel.textColor = self.textColor;
        selectedLabel.textColor = self.selectedTextColor;
        
        self.currentPage = selectedPage;
        
        __weak typeof(self) weakSelf = self;
        __block CGSize titleSize = [self.segmentTitles[self.currentPage] sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
        [UIView animateWithDuration:0.2
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             if (weakSelf.equalWidth) {
                                 weakSelf.indicatorView.frame = CGRectMake(selectedLabel.frame.origin.x+(selectedLabel.frame.size.width-(titleSize.width+20))/2, (selectedLabel.frame.size.height-titleSize.height)/2, titleSize.width+20, titleSize.height);
                             } else {
                                 weakSelf.indicatorView.frame = CGRectMake(selectedLabel.frame.origin.x, (selectedLabel.frame.size.height-titleSize.height)/2, selectedLabel.frame.size.width, titleSize.height);
                             }
                         } completion:nil];
        
        [self.pagedController scrollToPage:selectedPage];
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
