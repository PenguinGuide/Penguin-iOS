//
//  PGSettingsUpdateViewController.h
//  Penguin
//
//  Created by Jing Dai on 24/10/2016.
//  Copyright © 2016 Xinglian. All rights reserved.
//

typedef NS_ENUM(NSInteger, PGSettingsType) {
    PGSettingsTypeNickname,
    PGSettingsTypeSex,
    PGSettingsTypeLocation,
    PGSettingsTypeBirthday,
    PGSettingsTypePassword
};

#import "PGBaseViewController.h"

@interface PGSettingsUpdateViewController : PGBaseViewController

- (id)initWithType:(PGSettingsType)setttingType content:(NSString *)content;

@end
