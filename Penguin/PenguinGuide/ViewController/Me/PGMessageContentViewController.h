//
//  PGReplyMessagesViewController.h
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

typedef NS_ENUM(NSInteger, PGMessageContentType) {
    PGMessageContentTypeSystem,
    PGMessageContentTypeReply
};

#import "PGBaseViewController.h"

@interface PGMessageContentViewController : PGBaseViewController

- (id)initWithType:(PGMessageContentType)type;

@end
