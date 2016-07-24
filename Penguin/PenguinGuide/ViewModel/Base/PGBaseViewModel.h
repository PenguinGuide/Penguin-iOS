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

- (id)initWithAPIClient:(PGAPIClient *)apiClient;

- (void)requestData;

@end