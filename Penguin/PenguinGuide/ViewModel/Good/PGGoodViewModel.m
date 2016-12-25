//
//  PGGoodViewModel.m
//  Penguin
//
//  Created by Jing Dai on 28/09/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "PGGoodViewModel.h"

@interface PGGoodViewModel ()

@property (nonatomic, strong, readwrite) NSString *goodId;
@property (nonatomic, strong, readwrite) PGGood *good;
@property (nonatomic, strong, readwrite) NSArray *relatedGoods;

@end

@implementation PGGoodViewModel

- (void)requestGood:(NSString *)goodId
{
    self.goodId = goodId;
    if (goodId && goodId.length > 0) {
        PGWeakSelf(self);
        [self.apiClient pg_makeGetRequest:^(PGRKRequestConfig *config) {
            config.route = PG_Good;
            config.keyPath = nil;
            config.pattern = @{@"goodId":weakself.goodId};
            config.model = [PGGood new];
        } completion:^(id response) {
            weakself.good = [response firstObject];
        } failure:^(NSError *error) {
            weakself.error = error;
        }];
    }
}

@end
