//
//  PGArticleViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/15/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#define ArticleParagraphTextCell @"ArticleParagraphTextCell"
#define ArticleParagraphImageCell @"ArticleParagraphImageCell"
#define ArticleParagraphGIFImageCell @"ArticleParagraphGIFImageCell"

#import "PGArticleViewController.h"
#import "UIScrollView+PGScrollView.h"

// views
#import "PGArticleParagraphTextCell.h"
#import "PGArticleParagraphImageCell.h"
#import "PGArticleParagraphGIFImageCell.h"

// view model
#import "PGArticleViewModel.h"

#import "PGStringParser.h"

@interface PGArticleViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UICollectionView *articleCollectionView;

@property (nonatomic, strong) PGArticleViewModel *viewModel;

@end

@implementation PGArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.pageView = @"文章页面";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.articleCollectionView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*180/320)];
    self.imageView.image = [UIImage imageNamed:@"pg_article_top_banner"];
    [self.articleCollectionView setHeaderView:self.imageView naviTitle:@"从午间定食到深夜食堂！" rightNaviButton:nil];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
    [backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button_light"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:backButton];
    
    self.viewModel = [[PGArticleViewModel alloc] init];
    
    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html"]
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    PGStringParser *htmlParser = [PGStringParser htmlParserWithString:htmlString];
    self.viewModel.paragraphsArray = [htmlParser articleParsedStorages];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    // http://www.ithao123.cn/content-680069.html
    // http://blog.csdn.net/gxp1032901/article/details/41879557
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];
    
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
    
    [self.navigationController.navigationBar setBackgroundImage:[[UIImage imageNamed:@"pg_navigation_bg_image"] resizableImageWithCapInsets:UIEdgeInsetsZero resizingMode:UIImageResizingModeStretch] forBarMetrics:UIBarMetricsDefault];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.viewModel.paragraphsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id storage = self.viewModel.paragraphsArray[indexPath.item];
    if ([storage isKindOfClass:[PGParserTextStorage class]]) {
        PGArticleParagraphTextCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphTextCell forIndexPath:indexPath];
        
        PGParserTextStorage *textStorage = (PGParserTextStorage *)storage;
        [cell setCellWithStr:textStorage.text];
        
        return cell;
    } else if ([storage isKindOfClass:[PGParserImageStorage class]]) {
        PGParserImageStorage *imageStorage = (PGParserImageStorage *)storage;
        if (imageStorage.isGIF) {
            PGArticleParagraphGIFImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphGIFImageCell forIndexPath:indexPath];
            [cell setCellWithImage:imageStorage.image];
            
            return cell;
        } else {
            PGArticleParagraphImageCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:ArticleParagraphImageCell forIndexPath:indexPath];
            [cell setCellWithImage:imageStorage.image];
            
            return cell;
        }
    }
    
    return nil;
}

#pragma mark - <UICollectionViewDelegate>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(UISCREEN_WIDTH*180/320, 0, 0, 0);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    id storage = self.viewModel.paragraphsArray[indexPath.item];
    if ([storage isKindOfClass:[PGParserTextStorage class]]) {
        PGParserTextStorage *textStorage = (PGParserTextStorage *)storage;
        CGSize textSize = [textStorage.text boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-40, 1000) options:NSStringDrawingUsesLineFragmentOrigin context:nil].size;
        return CGSizeMake(UISCREEN_WIDTH, textSize.height+10);
    } else if ([storage isKindOfClass:[PGParserImageStorage class]]) {
        PGParserImageStorage *imageStorage = (PGParserImageStorage *)storage;
        CGFloat width = UISCREEN_WIDTH-40;
        CGFloat height = width*imageStorage.height/imageStorage.width;
        return CGSizeMake(width, height);
    }
    return CGSizeZero;
}

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView scrollViewShouldUpdate];
}

#pragma mark - <Setters && Getters>

- (UICollectionView *)articleCollectionView
{
    if (!_articleCollectionView) {
        _articleCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT) collectionViewLayout:[UICollectionViewFlowLayout new]];
        _articleCollectionView.dataSource = self;
        _articleCollectionView.delegate = self;
        _articleCollectionView.contentSize = CGSizeMake(UISCREEN_WIDTH, UISCREEN_HEIGHT+300);
        _articleCollectionView.backgroundColor = [UIColor clearColor];
        
        [_articleCollectionView registerClass:[PGArticleParagraphTextCell class] forCellWithReuseIdentifier:ArticleParagraphTextCell];
        [_articleCollectionView registerClass:[PGArticleParagraphImageCell class] forCellWithReuseIdentifier:ArticleParagraphImageCell];
        [_articleCollectionView registerClass:[PGArticleParagraphGIFImageCell class] forCellWithReuseIdentifier:ArticleParagraphGIFImageCell];
    }
    return _articleCollectionView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
