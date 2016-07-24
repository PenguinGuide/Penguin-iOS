//
//  PGArticleViewController.m
//  Penguin
//
//  Created by Jing Dai on 7/15/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGArticleViewController.h"
#import "UIScrollView+PGScrollView.h"

@interface PGArticleViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) UIScrollView *scrollView;

@end

@implementation PGArticleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    self.scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_HEIGHT)];
    self.scrollView.delegate = self;
    self.scrollView.contentSize = CGSizeMake(UISCREEN_WIDTH, UISCREEN_HEIGHT+300);
    self.scrollView.backgroundColor = [UIColor clearColor];
    [self.view addSubview:self.scrollView];
    
    self.imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0, 0, UISCREEN_WIDTH, UISCREEN_WIDTH*180/320)];
    self.imageView.image = [UIImage imageNamed:@"pg_article_top_banner"];
    [self.scrollView setHeaderView:self.imageView naviTitle:@"从午间定食到深夜食堂！" rightNaviButton:nil];
    
    UIButton *backButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 10, 60, 60)];
    [backButton setImage:[UIImage imageNamed:@"pg_navigation_back_button_light"] forState:UIControlStateNormal];
    [backButton addTarget:self action:@selector(backButtonClicked) forControlEvents:UIControlEventTouchUpInside];
    [backButton setContentHorizontalAlignment:UIControlContentHorizontalAlignmentLeft];
    [backButton setContentVerticalAlignment:UIControlContentVerticalAlignmentCenter];
    [self.view addSubview:backButton];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(0, self.imageView.bottom+15, UISCREEN_WIDTH, 600)];
    textView.backgroundColor = [UIColor whiteColor];
    textView.font = Theme.fontMedium;
    textView.editable = NO;
    textView.scrollEnabled = NO;
    textView.text = @"上海诸多“美食一条街”中，老派如云南南路、黄河路，新晋如进贤路、古羊路，但在上海马路文化的忠实拥趸和美食品鉴者口中，两条地处法租界却风格迥异的街道总会被一同提及——武康路和永康路。两条“康”字辈儿的街道，不仅是游人食客的聚集地，同时也是外国友人的心头好，一大批网红店应运而生，就连餐饮业态都有几分神似。这两条马路的美味加在一起，就是一个大写的洋气：精品咖啡、手工面包、网红冰淇淋、精酿啤酒吧、法式小酒馆 上海诸多“美食一条街”中，老派如云南南路、黄河路，新晋如进贤路、古羊路，但在上海马路文化的忠实拥趸和美食品鉴者口中，两条地处法租界却风格迥异的街道总会被一同提及——武康路和永康路。两条“康”字辈儿的街道，不仅是游人食客的聚集地，同时也是外国友人的心头好，一大批网红店应运而生，就连餐饮业态都有几分神似。这两条马路的美味加在一起，就是一个大写的洋气：精品咖啡、手工面包、网红冰淇淋、精酿啤酒吧、法式小酒馆 上海诸多“美食一条街”中，老派如云南南路、黄河路，新晋如进贤路、古羊路，但在上海马路文化的忠实拥趸和美食品鉴者口中，两条地处法租界却风格迥异的街道总会被一同提及——武康路和永康路。两条“康”字辈儿的街道，不仅是游人食客的聚集地，同时也是外国友人的心头好，一大批网红店应运而生，就连餐饮业态都有几分神似。这两条马路的美味加在一起，就是一个大写的洋气：精品咖啡、手工面包、网红冰淇淋、精酿啤酒吧、法式小酒馆 上海诸多“美食一条街”中，老派如云南南路、黄河路，新晋如进贤路、古羊路，但在上海马路文化的忠实拥趸和美食品鉴者口中，两条地处法租界却风格迥异的街道总会被一同提及——武康路和永康路。两条“康”字辈儿的街道，不仅是游人食客的聚集地，同时也是外国友人的心头好，一大批网红店应运而生，就连餐饮业态都有几分神似。这两条马路的美味加在一起，就是一个大写的洋气：精品咖啡、手工面包、网红冰淇淋、精酿啤酒吧、法式小酒馆 上海诸多“美食一条街”中，老派如云南南路、黄河路，新晋如进贤路、古羊路，但在上海马路文化的忠实拥趸和美食品鉴者口中，两条地处法租界却风格迥异的街道总会被一同提及——武康路和永康路。两条“康”字辈儿的街道，不仅是游人食客的聚集地，同时也是外国友人的心头好，一大批网红店应运而生，就连餐饮业态都有几分神似。这两条马路的美味加在一起，就是一个大写的洋气：精品咖啡、手工面包、网红冰淇淋、精酿啤酒吧、法式小酒馆 上海诸多“美食一条街”中，老派如云南南路、黄河路，新晋如进贤路、古羊路，但在上海马路文化的忠实拥趸和美食品鉴者口中，两条地处法租界却风格迥异的街道总会被一同提及——武康路和永康路。两条“康”字辈儿的街道，不仅是游人食客的聚集地，同时也是外国友人的心头好，一大批网红店应运而生，就连餐饮业态都有几分神似。这两条马路的美味加在一起，就是一个大写的洋气：精品咖啡、手工面包、网红冰淇淋、精酿啤酒吧、法式小酒馆";
    [self.scrollView addSubview:textView];
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

#pragma mark - <UIScrollViewDelegate>

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [scrollView scrollViewShouldUpdate];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
