//
//  PGCityGuideArticlesViewModel.h
//  Penguin
//
//  Created by Jing Dai on 28/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGBaseViewModel.h"

@interface PGCityGuideArticlesViewModel : PGBaseViewModel

@property (nonatomic, strong, readonly) NSArray *articlesArray;
@property (nonatomic, strong, readonly) NSArray *nextPageIndexes;

- (void)requestArticles:(NSString *)cityId;

@end
