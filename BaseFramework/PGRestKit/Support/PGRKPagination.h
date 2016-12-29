//
//  PGRKPagination.h
//  Penguin
//
//  Created by Jing Dai on 16/11/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGRKPagination : NSObject

@property (nonatomic, strong) NSString *paginationKey;
@property (nonatomic, strong) NSString *cursor;
@property (nonatomic, assign) NSInteger countPerPage;

@property (nonatomic, strong) NSArray *nextPageIndexesArray;
@property (nonatomic, strong) NSIndexSet *nextPageIndexesSet;

@property (nonatomic, assign) BOOL needPerformingBatchUpdate;
@property (nonatomic, assign) BOOL paginateSections;
@property (nonatomic, assign) NSInteger paginatedSection;
@property (nonatomic, assign) BOOL endFlag;

@end
