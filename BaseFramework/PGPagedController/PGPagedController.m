//
//  PGPagedController.m
//  Penguin
//
//  Created by Jing Dai on 24/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define PagerCell @"PagerCell"
#define PagerTag 1999

#import "PGPagedController.h"
#import "PGSegmentedControl.h"

@interface PGPagedController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UICollectionView *pagerCollectionView;

@property (nonatomic, strong, readwrite) NSArray *viewControllers;
@property (nonatomic, strong, readwrite) NSArray *titles;

@property (nonatomic, assign, readwrite) CGFloat segmentHeight;
@property (nonatomic, assign, readwrite) NSInteger currentPage;

@end

@implementation PGPagedController

- (id)initWithViewControllers:(NSArray *)viewControllers titles:(NSArray *)titles segmentHeight:(CGFloat)segmentHeight
{
    if (self = [super init]) {
        self.viewControllers = viewControllers;
        self.titles = titles;
        
        self.currentPage = 0;
        self.segmentHeight = segmentHeight > 0 ? segmentHeight : 60.f;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.pagerCollectionView];
}

- (void)reload
{
    self.currentPage = 0;
    
    [self.segmentedControl reloadSegmentTitles:self.titles];
    
    for (UIViewController *vc in self.childViewControllers) {
        [vc.view removeFromSuperview];
        [vc removeFromParentViewController];
        [vc didMoveToParentViewController:nil];
    }
    
    if (self.viewControllers.count > 0) {
        for (int i = 0; i < self.viewControllers.count; i++) {
            UIViewController *vc = self.viewControllers[i];
            [self addChildViewController:vc];
            [vc didMoveToParentViewController:self];
        }
    }
    
    [self.pagerCollectionView reloadData];
}

- (void)scrollToPage:(NSInteger)page
{
    self.currentPage = page;
    [self.pagerCollectionView setContentOffset:CGPointMake(self.view.frame.size.width*page, 0) animated:YES];
}

#pragma mark - <UICollectionView>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewControllers.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:PagerCell forIndexPath:indexPath];
    cell.backgroundColor = [UIColor clearColor];
    
    UIView *loadedPagerView = [cell.contentView viewWithTag:PagerTag];
    if (loadedPagerView) {
        [loadedPagerView removeFromSuperview];
    }
    
    UIViewController *vc = self.viewControllers[indexPath.item];
    vc.view.frame = CGRectMake(0, 0, collectionView.frame.size.width, collectionView.frame.size.height);
    vc.view.tag = PagerTag;
    [cell.contentView addSubview:vc.view];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(self.view.frame.size.width, collectionView.frame.size.height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsZero;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    CGFloat pageWidth = scrollView.frame.size.width;
    NSInteger currentPage = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl scrollToPage:currentPage];
}

#pragma mark - <Lazy Init>

- (UICollectionView *)pagerCollectionView
{
    if (!_pagerCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        
        _pagerCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.segmentHeight, self.view.frame.size.width, self.view.frame.size.height-self.segmentHeight) collectionViewLayout:layout];
        _pagerCollectionView.backgroundColor = [UIColor whiteColor];
        _pagerCollectionView.pagingEnabled = YES;
        _pagerCollectionView.dataSource = self;
        _pagerCollectionView.delegate = self;
        _pagerCollectionView.showsVerticalScrollIndicator = NO;
        _pagerCollectionView.showsHorizontalScrollIndicator = NO;
        if (self.disableScrolling) {
            _pagerCollectionView.scrollEnabled = NO;
        }
        
        [_pagerCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:PagerCell];
    }
    return _pagerCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
