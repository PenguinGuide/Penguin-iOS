//
//  PGArticleViewModel.h
//  Penguin
//
//  Created by Jing Dai on 7/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"
#import "PGArticle.h"

@interface PGArticleViewModel : PGBaseViewModel

@property (nonatomic, strong) NSString *articleId;
@property (nonatomic, strong) PGArticle *article;
@property (nonatomic, strong) NSArray *paragraphsArray;

@end
