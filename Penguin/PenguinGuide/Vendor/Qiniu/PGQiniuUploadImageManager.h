//
//  PGQiniuUploadImageManager.h
//  Penguin
//
//  Created by Jing Dai on 08/12/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PGQiniuUploadImageManager : NSObject

+ (PGQiniuUploadImageManager *)sharedManager;

- (void)uploadImage:(UIImage *)image completion:(void(^)(NSString *url))completion;

@end
