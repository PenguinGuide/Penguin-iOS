//
//  PGMessage.h
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <PGRestKit/PGRestKit.h>
#import "PGMessageContent.h"

@interface PGMessage : PGRKModel

@property (nonatomic, strong) PGMessageContent *content;
@property (nonatomic, strong) NSString *messageId;

@end
