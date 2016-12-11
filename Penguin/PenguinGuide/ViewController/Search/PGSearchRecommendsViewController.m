//
//  PGSearchRecommendsViewController.m
//  Penguin
//
//  Created by Jing Dai on 8/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define TagCell @"TagCell"
#define HistoryHeaderView @"HistoryHeaderView"
#define HistoryCell @"HistoryCell"

#import "PGSearchRecommendsViewController.h"
#import "PGSearchResultsViewController.h"

#import "PGSearchRecommendsViewModel.h"

#import "PGTagCell.h"
#import "PGSearchRecommendsHistoryCell.h"
#import "PGSearchRecommendsHistoryHeaderView.h"

#import "UICollectionViewLeftAlignedLayout.h"
#import "PGSearchTextField.h"

@interface PGSearchRecommendsViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UITextFieldDelegate>

@property (nonatomic, strong) PGSearchRecommendsViewModel *viewModel;

@property (nonatomic, strong) UICollectionView *searchCollectionView;
@property (nonatomic, strong) UIView *searchTextFieldContainerView;
@property (nonatomic, strong) PGSearchTextField *searchTextField;
@property (nonatomic, strong) UIButton *cancelButton;

@end

@implementation PGSearchRecommendsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = Theme.colorBackground;
    
    self.viewModel = [[PGSearchRecommendsViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"recommends" block:^(id changedObject) {
        NSArray *recommends = changedObject;
        if (recommends && [recommends isKindOfClass:[NSArray class]]) {
            weakself.viewModel.historyArray = [PGGlobal.cache objectForKey:@"search_keywords" fromTable:@"Search"];
            [weakself.searchCollectionView reloadData];
        }
        [weakself dismissLoading];
    }];
    
    [self.view addSubview:self.searchTextFieldContainerView];
    [self.searchTextFieldContainerView addSubview:self.searchTextField];
    [self.searchTextFieldContainerView addSubview:self.cancelButton];
    [self.view addSubview:self.searchCollectionView];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
//    [self.searchTextField becomeFirstResponder];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.searchCollectionView.delegate = self;
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
    
    if (self.viewModel.recommends.count == 0) {
        [self showLoading];
        [self.viewModel requestData];
    }
    
    self.navigationItem.leftBarButtonItem = nil;
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    self.searchCollectionView.delegate = nil;
    
    [self.searchTextField resignFirstResponder];
}

- (void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
}

- (void)dealloc
{
    [self unobserve];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.viewModel.recommends.count > 0) {
        if (self.viewModel.historyArray.count == 0) {
            return 1;
        } else {
            return 2;
        }
    }
    return 0;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (section == 0) {
        return self.viewModel.recommends.count;
    } else if (section == 1) {
        return self.viewModel.historyArray.count;
    }
    return 0;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        PGTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagCell forIndexPath:indexPath];
        
        [cell setCellWithKeyword:self.viewModel.recommends[indexPath.item]];
        
        return cell;
    } else if (indexPath.section == 1) {
        PGSearchRecommendsHistoryCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:HistoryCell forIndexPath:indexPath];
        
        [cell setCellWithStr:self.viewModel.historyArray[indexPath.item]];
        
        return cell;
    }
    
    return nil;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 1) {
        if (kind == UICollectionElementKindSectionHeader) {
            PGSearchRecommendsHistoryHeaderView *headerView = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:HistoryHeaderView forIndexPath:indexPath];
            
            return headerView;
        }
    }
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        return [PGTagCell keywordCellSize:self.viewModel.recommends[indexPath.item]];
    } else if (indexPath.section == 1) {
        return [PGSearchRecommendsHistoryCell cellSize];
    }
    return CGSizeZero;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (section == 1) {
        return CGSizeMake(UISCREEN_WIDTH, 40);
    }
    return CGSizeZero;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 10.f;
    } else {
        return 0.f;
    }
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return 10.f;
    } else {
        return 0.f;
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section == 0) {
        return UIEdgeInsetsMake(10, 15, 10, 15);
    } else {
        return UIEdgeInsetsZero;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.section == 0) {
        NSString *keyword = self.viewModel.recommends[indexPath.item];
        
        if (keyword && keyword.length > 0) {
            NSMutableArray *wordsArray = [NSMutableArray arrayWithArray:self.viewModel.historyArray];
            if ([wordsArray containsObject:keyword]) {
                [wordsArray removeObject:keyword];
            }
            [wordsArray insertObject:keyword atIndex:0];
            self.viewModel.historyArray = [NSArray arrayWithArray:wordsArray];
            [PGGlobal.cache putObject:self.viewModel.historyArray forKey:@"search_keywords" intoTable:@"Search"];
            
            PGSearchResultsViewController *searchResultsVC = [[PGSearchResultsViewController alloc] initWithKeyword:keyword];
            [self.navigationController pushViewController:searchResultsVC animated:YES];
        }
    } else if (indexPath.section == 1) {
        NSString *keyword = self.viewModel.historyArray[indexPath.item];
        
        PGSearchResultsViewController *searchResultsVC = [[PGSearchResultsViewController alloc] initWithKeyword:keyword];
        [self.navigationController pushViewController:searchResultsVC animated:YES];
    }
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= -64) {
        [self.navigationController.navigationBar pg_setBackgroundColor:Theme.colorBackground];
    } else {
        [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor clearColor]];
    }
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.searchTextField resignFirstResponder];
}

- (void)cancelButtonClicked
{
    PGGlobal.tempNavigationController = nil;
    NSLog(@"temp navi set to nil");
    [self.navigationController dismissViewControllerAnimated:NO completion:nil];
}

#pragma mark - <UITextFieldDelegate>

- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
    if (textField.text.length > 0) {
        NSMutableArray *wordsArray = [NSMutableArray arrayWithArray:self.viewModel.historyArray];
        if ([wordsArray containsObject:textField.text]) {
            [wordsArray removeObject:textField.text];
        }
        [wordsArray insertObject:textField.text atIndex:0];
        self.viewModel.historyArray = [NSArray arrayWithArray:wordsArray];
        [PGGlobal.cache putObject:self.viewModel.historyArray forKey:@"search_keywords" intoTable:@"Search"];
        
        PGSearchResultsViewController *searchResultsVC = [[PGSearchResultsViewController alloc] initWithKeyword:textField.text];
        [self.navigationController pushViewController:searchResultsVC animated:YES];
        return YES;
    }
    return NO;
}

#pragma mark - <Setters && Getters>

- (UICollectionView *)searchCollectionView {
	if(_searchCollectionView == nil) {
        UICollectionViewLeftAlignedLayout *layout = [UICollectionViewLeftAlignedLayout new];
		_searchCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, UISCREEN_WIDTH, UISCREEN_HEIGHT-64) collectionViewLayout:layout];
        _searchCollectionView.backgroundColor = Theme.colorBackground;
        _searchCollectionView.dataSource = self;
        _searchCollectionView.delegate = self;
        
        [_searchCollectionView registerClass:[PGTagCell class] forCellWithReuseIdentifier:TagCell];
        [_searchCollectionView registerClass:[PGSearchRecommendsHistoryHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:HistoryHeaderView];
        [_searchCollectionView registerClass:[PGSearchRecommendsHistoryCell class] forCellWithReuseIdentifier:HistoryCell];
	}
	return _searchCollectionView;
}

- (UIView *)searchTextFieldContainerView {
	if(_searchTextFieldContainerView == nil) {
		_searchTextFieldContainerView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, 64)];
        _searchTextFieldContainerView.backgroundColor = Theme.colorBackground;
	}
	return _searchTextFieldContainerView;
}

- (UITextField *)searchTextField {
    if(_searchTextField == nil) {
        _searchTextField = [[PGSearchTextField alloc] initWithFrame:CGRectMake(15, 25, UISCREEN_WIDTH-15-50, 30)];
        _searchTextField.placeholder = @"请输入关键词";
        _searchTextField.returnKeyType = UIReturnKeySearch;
        _searchTextField.delegate = self;
    }
    return _searchTextField;
}

- (UIButton *)cancelButton {
    if(_cancelButton == nil) {
        _cancelButton = [[UIButton alloc] initWithFrame:CGRectMake(UISCREEN_WIDTH-50, 25, 50, 30)];
        [_cancelButton.titleLabel setFont:Theme.fontSmallBold];
        [_cancelButton setTitleColor:Theme.colorText forState:UIControlStateNormal];
        [_cancelButton setTitle:@"取 消" forState:UIControlStateNormal];
        [_cancelButton addTarget:self action:@selector(cancelButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _cancelButton;
}

@end
