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

// view models
#import "PGArticleViewModel.h"

// models
#import "PGArticle.h"
#import "PGStringParser.h"

@interface PGArticleViewController () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UIScrollViewDelegate>

@property (nonatomic, strong, readwrite) UICollectionView *articleCollectionView;
@property (nonatomic, strong, readwrite) UIButton *backButton;

@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) PGArticleViewModel *viewModel;

@property (nonatomic, assign) BOOL animated;

@end

@implementation PGArticleViewController

- (id)initWithArticleId:(NSString *)articleId animated:(BOOL)animated
{
    if (self = [super init]) {
        self.articleId = articleId;
        self.animated = animated;
    }
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.pageView = @"文章页面";
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    [self.view addSubview:self.articleCollectionView];
    [self.view addSubview:self.backButton];
    
    if (self.animated) {
        self.articleCollectionView.alpha = 0.f;
    }
    
    self.viewModel = [[PGArticleViewModel alloc] initWithAPIClient:self.apiClient];
    self.viewModel.articleId = self.articleId;
    [self.viewModel requestData];
    
    PGWeakSelf(self);
    [self observe:self.viewModel keyPath:@"article" block:^(id changedObject) {
        PGArticle *article = changedObject;
        if (article && [article isKindOfClass:[PGArticle class]]) {
            weakself.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*9/16)];
            [weakself.imageView setWithImageURL:weakself.viewModel.article.image placeholder:nil completion:nil];
            [weakself.articleCollectionView setHeaderView:weakself.imageView naviTitle:weakself.viewModel.article.title rightNaviButton:nil];
        }
    }];
    
    NSString *htmlString = [[NSString alloc] initWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"demo" ofType:@"html"]
                                                           encoding:NSUTF8StringEncoding
                                                              error:nil];
    PGStringParser *htmlParser = [PGStringParser htmlParserWithString:htmlString];
    self.viewModel.paragraphsArray = [htmlParser articleParsedStorages];
    
    [self setNeedsStatusBarAppearanceUpdate];
}

- (void)animateCollectionView:(void (^)())completion
{
    self.articleCollectionView.frame = CGRectMake(0, UISCREEN_HEIGHT-300, self.articleCollectionView.width, self.articleCollectionView.height);
    self.articleCollectionView.alpha = 0.f;
    
    [UIView animateWithDuration:0.3f
                          delay:0.f
                        options:UIViewAnimationOptionCurveEaseOut
                     animations:^{
                         self.articleCollectionView.frame = CGRectMake(0, 0, self.articleCollectionView.width, self.articleCollectionView.height);
                         self.articleCollectionView.alpha = 0.4f;
                     } completion:^(BOOL finished) {
                         self.articleCollectionView.alpha = 1.f;
                         if (completion) {
                             completion();
                         }
                     }];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    
    [self.navigationController setNavigationBarHidden:YES animated:NO];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [self.navigationController setNavigationBarHidden:NO animated:NO];
}

- (void)dealloc
{
    [self unobserve];
}

- (UIStatusBarStyle)preferredStatusBarStyle
{
    return UIStatusBarStyleLightContent;
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
    return UIEdgeInsetsMake(UISCREEN_WIDTH*9/16+20, 0, 0, 0);
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

- (UIButton *)backButton {
    if(_backButton == nil) {
        _backButton = [[UIButton alloc] initWithFrame:CGRectMake(24, 35, 50, 50)];
        [_backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button_light"] forState:UIControlStateNormal];
        [_backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentTop];
        [_backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
        [_backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    }
    return _backButton;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
