//
//  PGChannelViewController.m
//  Penguin
//
//  Created by Jing Dai on 8/26/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define ArticleBannerCell @"ArticleBannerCell"

#import "PGChannelViewController.h"
#import "PGChannelAllCategoriesViewController.h"
#import "PGArticleViewController.h"

#import "PGChannelViewModel.h"

#import "PGArticleBannerCell.h"
#import "PGChannelCategoriesView.h"

@interface PGChannelViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, PGChannelCategoriesViewDelegate>

@property (nonatomic, strong) NSString *channelId;

@property (nonatomic, strong) PGChannelViewModel *viewModel;

@property (nonatomic, strong) UICollectionView *articlesCollectionView;
@property (nonatomic, strong) PGChannelCategoriesView *categoriesView;
@property (nonatomic, strong) UIView *naviTitleView;
@property (nonatomic, strong) UIView *channelInfoView;

@end

@implementation PGChannelViewController

- (id)initWithChannelId:(NSString *)channelId
{
    if (self = [super init]) {
        self.channelId = channelId;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = Theme.colorBackground;
    
    self.viewModel = [[PGChannelViewModel alloc] initWithAPIClient:self.apiClient];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"articlesArray" block:^(id changedObject) {
        NSArray *articlesArray = changedObject;
        if (articlesArray && [articlesArray isKindOfClass:[NSArray class]]) {
            [weakself.categoriesView reloadViewWithCategories:weakself.viewModel.channel.categoriesArray];
            [weakself.navigationItem setTitleView:weakself.naviTitleView];
            [weakself.articlesCollectionView reloadData];
        }
        [weakself dismissLoading];
    }];
    
    [self.view addSubview:self.articlesCollectionView];
    [self.view addSubview:self.categoriesView];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    self.articlesCollectionView.delegate = self;
    
    if (self.viewModel.articlesArray.count == 0) {
        [self showLoading];
        [self.viewModel requestChannel:self.channelId];
    }
    
    // http://www.cocoachina.com/bbs/read.php?tid=316263
    // http://blog.csdn.net/cx_wzp/article/details/47166601
    
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor clearColor]];
    [self.navigationController.navigationBar setShadowImage:[UIImage new]];
    [self.navigationController.navigationBar setTintColor:[UIColor whiteColor]];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    // http://stackoverflow.com/questions/15216245/uicollectionview-calling-scrollviewdidscroll-when-popped-from-the-navigation-st
    // http://stackoverflow.com/questions/24113751/scrollviewdidscroll-get-called-when-back-button-pressed-and-make-app-crash
    self.articlesCollectionView.delegate = nil;
    [self.navigationItem setTitleView:nil];
    
    [self.navigationController.navigationBar pg_reset];
}

- (void)dealloc
{
    [self unobserve];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.articlesArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGArticleBannerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleBannerCell forIndexPath:indexPath];
    
    [cell setCellWithArticle:self.viewModel.articlesArray[indexPath.item] allowGesture:YES];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(61, 0, 0, 0);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    return [PGArticleBannerCell cellSize];
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGArticleBanner *articleBanner = self.viewModel.articlesArray[indexPath.item];
    [[PGRouter sharedInstance] openURL:articleBanner.link];
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y >= -64+61) {
        [self.navigationController.navigationBar pg_setBackgroundColor:Theme.colorBackground];
    } else {
        [self.navigationController.navigationBar pg_setBackgroundColor:[UIColor clearColor]];
    }
}

#pragma mark - <PGChannelCategoriesViewDelegate>

- (void)channelCategoryDidSelect:(PGChannelCategory *)category
{
    if (category.categoryId && category.categoryId.length > 0) {
        [self showLoading];
        [self.viewModel requestArticles:self.viewModel.channel.channelId categoryId:category.categoryId];
    } else {
        [self showLoading];
        [self.viewModel requestArticles:self.viewModel.channel.channelId categoryId:nil];
    }
}

- (void)channelInfoCloseButtonClicked
{
    [self dismissPopup];
}

#pragma mark - <Lazy Init>

- (UICollectionView *)articlesCollectionView {
	if(_articlesCollectionView == nil) {
		_articlesCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _articlesCollectionView.backgroundColor = Theme.colorBackground;
        _articlesCollectionView.dataSource = self;
        _articlesCollectionView.delegate = self;
        
        [_articlesCollectionView registerClass:[PGArticleBannerCell class] forCellWithReuseIdentifier:ArticleBannerCell];
	}
	return _articlesCollectionView;
}

- (PGChannelCategoriesView *)categoriesView {
	if(_categoriesView == nil) {
		_categoriesView = [[PGChannelCategoriesView alloc] initWithFrame:CGRectMake(0, 64, UISCREEN_WIDTH, 61)];    // 8+45+8
        _categoriesView.delegate = self;
	}
	return _categoriesView;
}

- (UIView *)naviTitleView {
	if(_naviTitleView == nil) {
        NSString *naviTitleStr = self.viewModel.channel.name;
        CGSize size = [naviTitleStr sizeWithAttributes:@{NSFontAttributeName:Theme.fontSmallBold}];
		_naviTitleView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 12+5+size.width+5+12, 30)];
        _naviTitleView.backgroundColor = [UIColor clearColor];
        _naviTitleView.userInteractionEnabled = YES;
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 8, 12, 14)];
        [iconImageView setWithImageURL:self.viewModel.channel.icon placeholder:nil completion:nil];
        [_naviTitleView addSubview:iconImageView];
        
        UILabel *textLabel = [[UILabel alloc] initWithFrame:CGRectMake(12+5, 0, size.width, 30)];
        textLabel.font = Theme.fontSmallBold;
        textLabel.textColor = Theme.colorText;
        textLabel.text = naviTitleStr;
        [_naviTitleView addSubview:textLabel];
        
        UIImageView *arrowImageView = [[UIImageView alloc] initWithFrame:CGRectMake(12+5+size.width+5, 9, 12, 12)];
        arrowImageView.image = [UIImage imageNamed:@"pg_channel_info_arrow"];
        [_naviTitleView addSubview:arrowImageView];
        
        PGWeakSelf(self)
        [_naviTitleView setTapAction:^{
            if (weakself.viewModel.channel.desc) {
                [weakself showPopup:weakself.channelInfoView];
            }
        }];
	}
	return _naviTitleView;
}

- (UIView *)channelInfoView {
	if(_channelInfoView == nil) {
        CGFloat width = MIN(414, UISCREEN_WIDTH)-45*2;
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle defaultParagraphStyle] mutableCopy];
        paragraphStyle.lineSpacing = 10.f;
        NSAttributedString *descStr = [[NSAttributedString alloc] initWithString:self.viewModel.channel.desc
                                                                      attributes:@{NSFontAttributeName:Theme.fontExtraSmall,
                                                                                   NSForegroundColorAttributeName:Theme.colorText,
                                                                                   NSParagraphStyleAttributeName:paragraphStyle}];
        CGSize textSize = [descStr boundingRectWithSize:CGSizeMake(width-32*2, UISCREEN_HEIGHT) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        CGFloat height = 105+textSize.height+10+60-24;
		_channelInfoView = [[UIView alloc] initWithFrame:CGRectMake(45, (UISCREEN_HEIGHT-height)/2, width, height)];
        _channelInfoView.backgroundColor = Theme.colorBackground;
        _channelInfoView.clipsToBounds = YES;
        _channelInfoView.layer.cornerRadius = 10.f;
        
        UILabel *descLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, 105-24, width-32*2, textSize.height+10)];
        descLabel.numberOfLines = 0;
        descLabel.attributedText = descStr;
        [_channelInfoView addSubview:descLabel];
        
        UIImageView *iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(width/2-17/2.f, 20, 17, 20)];
        [iconImageView setWithImageURL:self.viewModel.channel.icon placeholder:nil completion:nil];
        [_channelInfoView addSubview:iconImageView];
        
        UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, iconImageView.pg_bottom+8, width, 16)];
        titleLabel.text = self.viewModel.channel.desc;
        titleLabel.font = Theme.fontMediumBold;
        titleLabel.textColor = Theme.colorText;
        titleLabel.textAlignment = NSTextAlignmentCenter;
        [_channelInfoView addSubview:titleLabel];
        
//        UILabel *countLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, titleLabel.pg_bottom+12, width, 12)];
//        countLabel.text = [NSString stringWithFormat:@"-共%@篇-", self.viewModel.channel.totalArticles];
//        countLabel.font = Theme.fontExtraSmall;
//        countLabel.textColor = Theme.colorLightText;
//        countLabel.textAlignment = NSTextAlignmentCenter;
//        [_channelInfoView addSubview:countLabel];
        
        UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(width/2-40, height-20-26, 80, 26)];
        closeButton.clipsToBounds = YES;
        closeButton.layer.cornerRadius = 13.f;
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton.titleLabel setFont:Theme.fontSmallBold];
        [closeButton setBackgroundColor:Theme.colorExtraHighlight];
        [closeButton addTarget:self action:@selector(channelInfoCloseButtonClicked) forControlEvents:UIControlEventTouchUpInside];
        [_channelInfoView addSubview:closeButton];
	}
	return _channelInfoView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
