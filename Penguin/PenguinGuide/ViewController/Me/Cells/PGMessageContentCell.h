//
//  PGMessageContentCell.h
//  Penguin
//
//  Created by Jing Dai on 27/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PGMessage.h"

@interface PGMessageContentCell : PGBaseCollectionViewCell

- (void)setCellWithMessage:(PGMessage *)message type:(NSString *)type;

@end
