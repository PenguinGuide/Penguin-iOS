//
//  PGBaseViewModel.h
//  Penguin
//
//  Created by Jing Dai on 7/12/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PGAPIClient.h"

@interface PGBaseViewModel : NSObject

@property (nonatomic, strong, readonly) PGAPIClient *apiClient;
@property (nonatomic, strong, readwrite) NSString *cursor;
@property (nonatomic, assign, readwrite) NSInteger page;

@property (nonatomic, assign, readwrite) BOOL endFlag;
@property (nonatomic, strong, readwrite) NSError *error;

- (id)initWithAPIClient:(PGAPIClient *)apiClient;

- (void)requestData;
- (void)loadNextPage;

@end
