//
//  PGArticleParagraphInfoCell.m
//  Penguin
//
//  Created by Jing Dai on 9/19/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

static NSString *TagCell = @"TagCell";

#import "PGArticleParagraphInfoCell.h"
#import "PGTagCell.h"

@interface PGArticleParagraphInfoCell () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@property (nonatomic, strong) UILabel *dayLabel;
@property (nonatomic, strong) UILabel *monthLabel;
@property (nonatomic, strong) UIImageView *channelImageView;
@property (nonatomic, strong) UILabel *channelLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *designerLabel;
@property (nonatomic, strong) UILabel *descLabel;
@property (nonatomic, strong) UIView *titleHorizontalLine;

@property (nonatomic, strong) UICollectionView *tagsCollectionView;
@property (nonatomic, strong) PGArticle *article;

@end

@implementation PGArticleParagraphInfoCell

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initialize];
    }
    return self;
}

- (void)initialize
{
    [self.contentView addSubview:self.dayLabel];
    [self.contentView addSubview:self.monthLabel];
    [self.contentView addSubview:self.channelImageView];
    [self.contentView addSubview:self.channelLabel];
    
    UIView *dateHorizontalLine = [[UIView alloc] initWithFrame:CGRectMake(30, self.dayLabel.pg_bottom, 30, 1/[UIScreen mainScreen].scale)];
    dateHorizontalLine.backgroundColor = [UIColor colorWithHexString:@"282527"];
    [self.contentView addSubview:dateHorizontalLine];
    
    UIView *dateVerticalLine = [[UIView alloc] initWithFrame:CGRectMake(self.dayLabel.pg_right+9, 20, 2, 30)];
    dateVerticalLine.backgroundColor = Theme.colorText;
    [self.contentView addSubview:dateVerticalLine];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    
    self.titleHorizontalLine = [[UIView alloc] initWithFrame:CGRectMake(30, self.subtitleLabel.pg_bottom+15, 40, 1/[UIScreen mainScreen].scale)];
    self.titleHorizontalLine.backgroundColor = Theme.colorText;
    [self.contentView addSubview:self.titleHorizontalLine];
    
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.designerLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.tagsCollectionView];
}

- (void)setCellWithArticle:(PGArticle *)article
{
    if (article) {
        self.article = article;
        
        self.dayLabel.text = @"10";
        self.monthLabel.text = @"2016/9";
        
        if ([article.channel isEqualToString:@"city_guide"]) {
            self.channelImageView.image = [UIImage imageNamed:@"pg_home_article_category_city_guide"];
            self.channelLabel.text = @"城市指南";
        }
        
        CGFloat titleHeight = 0.f;
        CGFloat subtitleHeight = 0.f;
        
        if (article.title.length > 0) {
            titleHeight = [article.title boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-60, 500)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26.f weight:UIFontWeightRegular]}
                                                      context:nil].size.height;
            self.titleLabel.pg_height = titleHeight;
        }
        
        if (article.subTitle.length > 0) {
            subtitleHeight = [article.subTitle boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-60, 500)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f weight:UIFontWeightRegular]}
                                                            context:nil].size.height;
            self.subtitleLabel.frame = CGRectMake(self.subtitleLabel.pg_x, self.titleLabel.pg_bottom+10, self.subtitleLabel.pg_width, subtitleHeight);
        }
        
        self.titleLabel.text = article.title;
        self.subtitleLabel.text = article.subTitle;
        self.titleHorizontalLine.frame = CGRectMake(30, self.subtitleLabel.pg_bottom+15, 40, 1/[UIScreen mainScreen].scale);
        
        self.authorLabel.text = [NSString stringWithFormat:@"文 | %@", article.author];
        self.designerLabel.text = [NSString stringWithFormat:@"图 | %@", article.designer];
        self.descLabel.text = article.desc;
        
        self.authorLabel.frame = CGRectMake(self.authorLabel.pg_x, self.subtitleLabel.pg_bottom+30, self.authorLabel.pg_width, self.authorLabel.pg_height);
        self.designerLabel.frame = CGRectMake(self.designerLabel.pg_x, self.authorLabel.pg_bottom+10, self.designerLabel.pg_width, self.designerLabel.pg_height);
        self.descLabel.frame = CGRectMake(self.descLabel.pg_x, self.designerLabel.pg_bottom+10, self.descLabel.pg_width, self.descLabel.pg_height);
        
        if (article.tagsArray.count > 0) {
            self.tagsCollectionView.frame = CGRectMake(self.tagsCollectionView.pg_x, self.descLabel.pg_bottom+20, self.descLabel.pg_width, 20.f);
        } else {
            self.tagsCollectionView.frame = CGRectMake(self.tagsCollectionView.pg_x, self.descLabel.pg_bottom+20, self.descLabel.pg_width, 0.f);
        }
        [self.tagsCollectionView reloadData];
    }
}

+ (CGSize)cellSize:(PGArticle *)article
{
    if (article) {
        CGFloat titleHeight = 0.f;
        CGFloat subtitleHeight = 0.f;
        
        if (article.title.length > 0) {
            titleHeight = [article.title boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-60, 500)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:26.f weight:UIFontWeightRegular]}
                                                      context:nil].size.height;
        }
        
        if (article.subTitle.length > 0) {
            subtitleHeight = [article.subTitle boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-60, 500)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f weight:UIFontWeightRegular]}
                                                            context:nil].size.height;
        }
        CGFloat height = 20+28+20+titleHeight+10+subtitleHeight+30+12+10+12+10+12+20;
        if (article.tagsArray.count > 0) {
            return CGSizeMake(UISCREEN_WIDTH, height+30.f);
        } else {
            return CGSizeMake(UISCREEN_WIDTH, height+10.f);
        }
    }
    return CGSizeZero;
}

#pragma mark - <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.article.tagsArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGTagCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:TagCell forIndexPath:indexPath];
    
    PGTag *tag = self.article.tagsArray[indexPath.item];
    [cell setCellWithTagName:tag.name];
    
    return cell;
}

#pragma mark - <UICollectionViewDelegate>

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    return UIEdgeInsetsMake(0, 30, 0, 30);
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    PGTag *tag = self.article.tagsArray[indexPath.item];
    
    return [PGTagCell cellSize:tag.name];
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.f;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0.f;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(tagDidSelect:)]) {
        [self.delegate tagDidSelect:self.article.tagsArray[indexPath.item]];
    }
}

#pragma mark - <Setters && Getters>

- (UILabel *)dayLabel
{
    if (!_dayLabel) {
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 19, 30, 22)];
        _dayLabel.font = [UIFont boldSystemFontOfSize:22.f];
        _dayLabel.textAlignment = NSTextAlignmentCenter;
        _dayLabel.textColor = [UIColor colorWithHexString:@"282527"];
    }
    return _dayLabel;
}

- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.dayLabel.pg_bottom+1/[UIScreen mainScreen].scale, 30, 8)];
        _monthLabel.font = [UIFont boldSystemFontOfSize:8.f];
        _monthLabel.textAlignment = NSTextAlignmentCenter;
        _monthLabel.textColor = [UIColor colorWithHexString:@"282527"];
    }
    return _monthLabel;
}

- (UIImageView *)channelImageView
{
    if (!_channelImageView) {
        _channelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.dayLabel.pg_right+20, 20, 28, 28)];
    }
    return _channelImageView;
}

- (UILabel *)channelLabel
{
    if (!_channelLabel) {
        _channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.channelImageView.pg_right+5, 20, 100, 28)];
        _channelLabel.font = Theme.fontLargeBold;
        _channelLabel.textColor = Theme.colorText;
    }
    return _channelLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.channelImageView.pg_bottom+20, UISCREEN_WIDTH-60, 28)];
        _titleLabel.font = [UIFont systemFontOfSize:26.f weight:UIFontWeightRegular];
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.titleLabel.pg_bottom+10, UISCREEN_WIDTH-60, 16)];
        _subtitleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightRegular];
        _subtitleLabel.textColor = Theme.colorLightText;
    }
    return _subtitleLabel;
}

- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.subtitleLabel.pg_bottom+30, UISCREEN_WIDTH-60, 12)];
        _authorLabel.font = Theme.fontExtraSmallBold;
        _authorLabel.textColor = Theme.colorText;
    }
    return _authorLabel;
}

- (UILabel *)designerLabel
{
    if (!_designerLabel) {
        _designerLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.authorLabel.pg_bottom+10, UISCREEN_WIDTH-60, 12)];
        _designerLabel.font = Theme.fontExtraSmallBold;
        _designerLabel.textColor = Theme.colorText;
    }
    return _designerLabel;
}

- (UILabel *)descLabel
{
    if (!_descLabel) {
        _descLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.designerLabel.pg_bottom+10, UISCREEN_WIDTH-60, 12)];
        _descLabel.font = Theme.fontExtraSmallBold;
        _descLabel.textColor = Theme.colorText;
    }
    return _descLabel;
}

- (UICollectionView *)tagsCollectionView
{
    if (!_tagsCollectionView) {
        UICollectionViewFlowLayout *layout = [UICollectionViewFlowLayout new];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        _tagsCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, self.descLabel.pg_bottom+20, UISCREEN_WIDTH, 20) collectionViewLayout:layout];
        _tagsCollectionView.dataSource = self;
        _tagsCollectionView.delegate = self;
        _tagsCollectionView.backgroundColor = [UIColor whiteColor];
        
        [_tagsCollectionView registerClass:[PGTagCell class] forCellWithReuseIdentifier:TagCell];
    }
    return _tagsCollectionView;
}

@end
