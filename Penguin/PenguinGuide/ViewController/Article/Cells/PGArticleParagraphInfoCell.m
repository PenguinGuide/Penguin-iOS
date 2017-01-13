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
@property (nonatomic, strong) UILabel *yearLabel;
@property (nonatomic, strong) UIImageView *channelImageView;
@property (nonatomic, strong) UILabel *channelLabel;
@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *subtitleLabel;
@property (nonatomic, strong) UILabel *authorLabel;
@property (nonatomic, strong) UILabel *designerLabel;
@property (nonatomic, strong) UILabel *photographerLabel;
@property (nonatomic, strong) UILabel *descLabel;

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
    [self.contentView addSubview:self.yearLabel];
    [self.contentView addSubview:self.monthLabel];
    [self.contentView addSubview:self.dayLabel];
    
    UIView *verticleLine = [[UIView alloc] initWithFrame:CGRectMake(80, 23, 2, 26)];
    verticleLine.backgroundColor = Theme.colorText;
    [self.contentView addSubview:verticleLine];
    
    [self.contentView addSubview:self.channelImageView];
    [self.contentView addSubview:self.channelLabel];
    
    [self.contentView addSubview:self.titleLabel];
    [self.contentView addSubview:self.subtitleLabel];
    
    [self.contentView addSubview:self.authorLabel];
    [self.contentView addSubview:self.designerLabel];
    [self.contentView addSubview:self.photographerLabel];
    [self.contentView addSubview:self.descLabel];
    [self.contentView addSubview:self.tagsCollectionView];
}

- (void)setCellWithArticle:(PGArticle *)article
{
    if (article) {
        self.article = article;
        
        if (article.date && article.date.length > 0) {
            NSArray *datesArray = [article.date componentsSeparatedByString:@"/"];
            if (datesArray.count == 3) {
                NSArray *dates = [article.date componentsSeparatedByString:@"/"];
                if (dates.count == 3) {
                    self.yearLabel.text = dates[0];
                    self.dayLabel.text = dates[2];
                    
                    NSString *month = dates[1];
                    if ([month isEqualToString:@"1"]) {
                        self.monthLabel.text = @"JAN.";
                    } else if ([month isEqualToString:@"2"]) {
                        self.monthLabel.text = @"FEB.";
                    } else if ([month isEqualToString:@"3"]) {
                        self.monthLabel.text = @"MAR.";
                    } else if ([month isEqualToString:@"4"]) {
                        self.monthLabel.text = @"APR.";
                    } else if ([month isEqualToString:@"5"]) {
                        self.monthLabel.text = @"MAY.";
                    } else if ([month isEqualToString:@"6"]) {
                        self.monthLabel.text = @"JUN.";
                    } else if ([month isEqualToString:@"7"]) {
                        self.monthLabel.text = @"JUL.";
                    } else if ([month isEqualToString:@"8"]) {
                        self.monthLabel.text = @"AUG.";
                    } else if ([month isEqualToString:@"9"]) {
                        self.monthLabel.text = @"SEP.";
                    } else if ([month isEqualToString:@"10"]) {
                        self.monthLabel.text = @"OCT.";
                    } else if ([month isEqualToString:@"11"]) {
                        self.monthLabel.text = @"NOV.";
                    } else if ([month isEqualToString:@"12"]) {
                        self.monthLabel.text = @"DEC.";
                    }
                }
            }
        }
        
        if (self.article.channel) {
            [self.channelImageView setWithImageURL:self.article.channelIcon placeholder:nil completion:nil];
            [self.channelLabel setText:self.article.channel];
        }
        
        CGFloat titleHeight = 0.f;
        CGFloat subtitleHeight = 0.f;
        
        if (article.title.length > 0) {
            titleHeight = [article.title boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-60, 500)
                                                      options:NSStringDrawingUsesLineFragmentOrigin
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:36.f weight:UIFontWeightBold]}
                                                      context:nil].size.height;
            self.titleLabel.pg_height = titleHeight;
        }
        
        if (article.subTitle.length > 0) {
            subtitleHeight = [article.subTitle boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-60, 500)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f weight:UIFontWeightBold]}
                                                            context:nil].size.height;
            self.subtitleLabel.frame = CGRectMake(self.subtitleLabel.pg_x, self.titleLabel.pg_bottom+10, self.subtitleLabel.pg_width, subtitleHeight);
        } else {
            self.subtitleLabel.frame = CGRectMake(self.subtitleLabel.pg_x, self.titleLabel.pg_bottom+10, self.subtitleLabel.pg_width, 0);
        }
        
        self.titleLabel.text = article.title;
        self.subtitleLabel.text = article.subTitle;
        
        if (article.author && article.author.length > 0) {
            self.authorLabel.text = [NSString stringWithFormat:@"文 | %@", article.author];
            self.authorLabel.frame = CGRectMake(self.authorLabel.pg_x, self.subtitleLabel.pg_bottom+15, self.authorLabel.pg_width, self.authorLabel.pg_height);
            self.authorLabel.hidden = NO;
        } else {
            self.authorLabel.hidden = YES;
        }
        
        if (article.designer && article.designer.length > 0) {
            self.designerLabel.text = [NSString stringWithFormat:@"设计 | %@", article.designer];
            if (article.author && article.author.length > 0) {
                self.designerLabel.frame = CGRectMake(self.designerLabel.pg_x, self.authorLabel.pg_bottom+10, self.designerLabel.pg_width, self.designerLabel.pg_height);
            } else {
                self.designerLabel.frame = CGRectMake(self.designerLabel.pg_x, self.subtitleLabel.pg_bottom+10, self.designerLabel.pg_width, self.designerLabel.pg_height);
            }
            self.designerLabel.hidden = NO;
        } else {
            self.designerLabel.hidden = YES;
        }
        
        if (article.photographer && article.photographer.length > 0) {
            self.photographerLabel.text = [NSString stringWithFormat:@"摄影 | %@", article.photographer];
            if (article.author && article.author.length > 0 && article.designer && article.designer.length > 0) {
                self.photographerLabel.frame = CGRectMake(32, self.designerLabel.pg_bottom+10, self.photographerLabel.pg_width, self.photographerLabel.pg_height);
            } else if (article.author && article.author.length > 0) {
                self.photographerLabel.frame = CGRectMake(32, self.authorLabel.pg_bottom+10, self.photographerLabel.pg_width, self.photographerLabel.pg_height);
            } else if (article.designer && article.designer.length > 0) {
                self.photographerLabel.frame = CGRectMake(32, self.designerLabel.pg_bottom+10, self.photographerLabel.pg_width, self.photographerLabel.pg_height);
            } else {
                self.photographerLabel.frame = CGRectMake(32, self.subtitleLabel.pg_bottom+10, self.photographerLabel.pg_width, self.photographerLabel.pg_height);
            }
            self.photographerLabel.hidden = NO;
        } else {
            self.photographerLabel.hidden = YES;
        }
        
        if (article.desc && article.desc.length > 0) {
            self.descLabel.text = article.desc;
            if (!self.photographerLabel.hidden) {
                self.descLabel.frame = CGRectMake(self.descLabel.pg_x, self.photographerLabel.pg_bottom+10, self.descLabel.pg_width, self.descLabel.pg_height);
            } else if (!self.designerLabel.hidden) {
                self.descLabel.frame = CGRectMake(self.descLabel.pg_x, self.designerLabel.pg_bottom+10, self.descLabel.pg_width, self.descLabel.pg_height);
            } else {
                self.descLabel.frame = CGRectMake(self.descLabel.pg_x, self.authorLabel.pg_bottom+10, self.descLabel.pg_width, self.descLabel.pg_height);
            }
            self.descLabel.hidden = NO;
        } else {
            self.descLabel.hidden = YES;
        }
        
        if (article.tagsArray.count > 0) {
            if (!self.descLabel.hidden) {
                self.tagsCollectionView.frame = CGRectMake(self.tagsCollectionView.pg_x, self.descLabel.pg_bottom+20, self.descLabel.pg_width, 20.f);
            } else {
                if (!self.photographerLabel.hidden) {
                    self.tagsCollectionView.frame = CGRectMake(self.tagsCollectionView.pg_x, self.photographerLabel.pg_bottom+20, self.descLabel.pg_width, 20.f);
                } else if (!self.designerLabel.hidden) {
                    self.tagsCollectionView.frame = CGRectMake(self.tagsCollectionView.pg_x, self.designerLabel.pg_bottom+20, self.descLabel.pg_width, 20.f);
                } else {
                    self.tagsCollectionView.frame = CGRectMake(self.tagsCollectionView.pg_x, self.authorLabel.pg_bottom+20, self.descLabel.pg_width, 20.f);
                }
            }
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
                                                   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:36.f weight:UIFontWeightBold]}
                                                      context:nil].size.height;
        }
        
        if (article.subTitle.length > 0) {
            subtitleHeight = [article.subTitle boundingRectWithSize:CGSizeMake(UISCREEN_WIDTH-60, 500)
                                                            options:NSStringDrawingUsesLineFragmentOrigin
                                                         attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:14.f weight:UIFontWeightBold]}
                                                            context:nil].size.height;
        }
        CGFloat copyrightInfoHeight = 0.f;
        if (article.author && article.author.length > 0) {
            copyrightInfoHeight = copyrightInfoHeight + 12;
        }
        if (article.designer && article.designer.length > 0) {
            copyrightInfoHeight = copyrightInfoHeight + 10 + 12;
        }
        if (article.photographer && article.photographer.length > 0) {
            copyrightInfoHeight = copyrightInfoHeight + 10 + 12;
        }
        CGFloat height = 21+30+19+titleHeight+10+subtitleHeight+15+copyrightInfoHeight+10+20;
        if (article.tagsArray.count > 0) {
            return CGSizeMake(UISCREEN_WIDTH, height+20.f+30.f);
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
        _dayLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, 21, 48, 30)];
        _dayLabel.font = [UIFont systemFontOfSize:36.f weight:UIFontWeightBold];
        _dayLabel.textColor = Theme.colorText;
    }
    return _dayLabel;
}

- (UILabel *)monthLabel
{
    if (!_monthLabel) {
        _monthLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, 21, 50, 15-1)];
        _monthLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightBold];
        _monthLabel.textColor = Theme.colorText;
    }
    return _monthLabel;
}

- (UILabel *)yearLabel
{
    if (!_yearLabel) {
        _yearLabel = [[UILabel alloc] initWithFrame:CGRectMake(90, self.monthLabel.pg_bottom+2, 50, 15-1)];
        _yearLabel.font = [UIFont systemFontOfSize:15.f weight:UIFontWeightBold];
        _yearLabel.textColor = Theme.colorText;
    }
    return _yearLabel;
}

- (UIImageView *)channelImageView
{
    if (!_channelImageView) {
        _channelImageView = [[UIImageView alloc] initWithFrame:CGRectMake(self.monthLabel.pg_right+20, 21, 28, 28)];
    }
    return _channelImageView;
}

- (UILabel *)channelLabel
{
    if (!_channelLabel) {
        _channelLabel = [[UILabel alloc] initWithFrame:CGRectMake(self.channelImageView.pg_right+8, 21, 100, 28)];
        _channelLabel.font = Theme.fontLargeBold;
        _channelLabel.textColor = Theme.colorText;
    }
    return _channelLabel;
}

- (UILabel *)titleLabel
{
    if (!_titleLabel) {
        _titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.dayLabel.pg_bottom+19, UISCREEN_WIDTH-60, 28)];
        _titleLabel.font = [UIFont systemFontOfSize:36.f weight:UIFontWeightBold];
        _titleLabel.textColor = Theme.colorText;
        _titleLabel.numberOfLines = 0;
    }
    return _titleLabel;
}

- (UILabel *)subtitleLabel
{
    if (!_subtitleLabel) {
        _subtitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(30, self.titleLabel.pg_bottom+10, UISCREEN_WIDTH-60, 16)];
        _subtitleLabel.font = [UIFont systemFontOfSize:14.f weight:UIFontWeightBold];
        _subtitleLabel.textColor = Theme.colorLightText;
    }
    return _subtitleLabel;
}

- (UILabel *)authorLabel
{
    if (!_authorLabel) {
        _authorLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, self.subtitleLabel.pg_bottom+15, UISCREEN_WIDTH-60, 12)];
        _authorLabel.font = Theme.fontMediumBold;
        _authorLabel.textColor = Theme.colorText;
    }
    return _authorLabel;
}

- (UILabel *)designerLabel
{
    if (!_designerLabel) {
        _designerLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, self.authorLabel.pg_bottom+10, UISCREEN_WIDTH-60, 12)];
        _designerLabel.font = Theme.fontMediumBold;
        _designerLabel.textColor = Theme.colorText;
    }
    return _designerLabel;
}

- (UILabel *)photographerLabel
{
    if (!_photographerLabel) {
        _photographerLabel = [[UILabel alloc] initWithFrame:CGRectMake(32, self.designerLabel.pg_bottom+10, UISCREEN_WIDTH-60, 12)];
        _photographerLabel.font = Theme.fontMediumBold;
        _photographerLabel.textColor = Theme.colorText;
    }
    return _photographerLabel;
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
