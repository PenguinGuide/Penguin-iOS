//
//  PGPagedController.m
//  Penguin
//
//  Created by Jing Dai on 24/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define PagerCell @"PagerCell"

#import "PGPagedController.h"
#import "PGSegmentedControl.h"

@interface PGPagedController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong, readwrite) UICollectionView *pagerCollectionView;

@property (nonatomic, strong, readwrite) NSArray *viewControllers;

@property (nonatomic, assign, readwrite) CGFloat segmentHeight;
@property (nonatomic, assign, readwrite) NSInteger currentPage;

@end

@implementation PGPagedController

- (id)initWithViewControllers:(NSArray *)viewControllers segmentHeight:(CGFloat)segmentHeight
{
    if (self = [super init]) {
        self.viewControllers = viewControllers;
        
        self.currentPage = 0;
        self.segmentHeight = segmentHeight;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self.view addSubview:self.pagerCollectionView];
}

- (void)reload:(NSArray *)viewControllers
{
    [self.childViewControllers enumerateObjectsUsingBlock:^(__kindof UIViewController * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        [obj willMoveToParentViewController:nil];
        /**
         *** IMPORTANT ***
         because addSubview retain only view, not controller. because view is not released when viewcontroller is released,
         and this cause crash if you'll try to do anything with view that is related to (already) released controller.
         http://stackoverflow.com/questions/9144959/how-to-retain-view-after-addsubview-of-uiviewcontroller-with-arc
         */
        [obj.view removeFromSuperview];
        [obj removeFromParentViewController];
        
        obj = nil;
    }];
    
    self.viewControllers = viewControllers;
    self.currentPage = 0;
    
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
    
    [cell.contentView.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
    
    UIViewController *vc = self.viewControllers[indexPath.item];
    if (![self.childViewControllers containsObject:vc]) {
        [self addChildViewController:vc];
    }
    vc.view.frame = CGRectMake(0, 0, collectionView.frame.size.width, collectionView.frame.size.height);
    [cell.contentView addSubview:vc.view];
    [vc didMoveToParentViewController:self];
    
    return cell;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return CGSizeMake(collectionView.frame.size.width, collectionView.frame.size.height);
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
    self.currentPage = scrollView.contentOffset.x / pageWidth;
    
    [self.segmentedControl scrollToPage:self.currentPage];
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
