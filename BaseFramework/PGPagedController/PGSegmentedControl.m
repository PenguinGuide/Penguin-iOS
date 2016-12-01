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
@property (nonatomic, strong) NSArray *titles;
@property (nonatomic, strong) NSMutableArray *labels;
@property (nonatomic, assign) NSInteger currentPage;

@end

@implementation PGSegmentedControl

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initCommon];
    }
    return self;
}

- (void)initCommon
{
    // default attribute values
    self.scrollView.backgroundColor = [UIColor clearColor];
    self.labels = [NSMutableArray new];
    
    self.scrollView = [[PGSegmentedScrollView alloc] initWithFrame:CGRectMake(0, 0, self.frame.size.width, self.frame.size.height)];
    self.scrollView.showsVerticalScrollIndicator = NO;
    self.scrollView.showsHorizontalScrollIndicator = NO;
    self.scrollView.delegate = self;
    [self addSubview:self.scrollView];
}

- (void)reloadWithTitles:(NSArray *)titles Class:(__unsafe_unretained Class)SelectedViewClass
{
    for (UIView *subview in self.scrollView.subviews) {
        [subview removeFromSuperview];
    }
    
    self.currentPage = 0;
    self.titles = titles;
    [self.labels removeAllObjects];
    
    if (titles.count > 0) {
        float totalWidth = self.margin;
        for (int i = 0; i < titles.count; i++) {
            NSString *title = titles[i];
            float titleWidth = [title sizeWithAttributes:@{NSFontAttributeName:self.textFont}].width+15;
            
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
                    self.indicatorView.frame = CGRectMake(firstLabel.frame.origin.x, (firstLabel.frame.size.height-titleSize.height)/2, firstLabel.frame.size.width, titleSize.height);
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
        __block CGSize titleSize = [self.titles[self.currentPage] sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
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
        __block CGSize titleSize = [self.titles[self.currentPage] sizeWithAttributes:@{NSFontAttributeName:self.textFont}];
        [UIView animateWithDuration:0.2
                              delay:0.f
                            options:UIViewAnimationOptionCurveEaseInOut
                         animations:^{
                             weakSelf.indicatorView.frame = CGRectMake(selectedLabel.frame.origin.x, (selectedLabel.frame.size.height-titleSize.height)/2, selectedLabel.frame.size.width, titleSize.height);
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
