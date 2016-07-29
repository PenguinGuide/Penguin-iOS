//
//  ViewController.m
//  PenguinGuide
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "ViewController.h"
#import "PGRouter.h"
#import "UIView+PGView.h"

@interface ViewController ()

@property (nonatomic, strong) UICollectionView *demoCollectionView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor redColor];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://user/notes" toHandler:^(NSDictionary *params) {
        NSLog(@"route to: qiechihe://user/notes params: %@", params);
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://user/boards" toHandler:^(NSDictionary *params) {
        NSLog(@"route to: qiechihe://user/boards");
    }];
    
    [[PGRouter sharedInstance] registerRoute:@"qiechihe://notes" toHandler:^(NSDictionary *params) {
        NSLog(@"route to: qiechihe://notes");
    }];
    
    [[PGRouter sharedInstance] openURL:@"qiechihe://user/notes?noteId=11111&name=Kobe"];
    
    /*
     https://mp.weixin.qq.com/s?__biz=MjM5Mzc5NTk1OQ==&mid=2652993857&idx=1&sn=4d880cfe11c53883936cdfec2eea035e&scene=1&srcid=0726bMqgQq83Vy3DYdGozUOH&key=8dcebf9e179c9f3a77e87194e4cdb2f5b2115231bbc002fc383bd311f9f022a332bbb769437be986b8474a8023f85246&ascene=0&uin=MjE1Mzk3NTE4NA%3D%3D&devicetype=iMac+MacBookPro11%2C2+OSX+OSX+10.11.5+build(15F34)&version=11020201&pass_ticket=eUkBe1UGTlSU8zz07fdsbUp1VwYskQcPsPWfCyfhZU52XkPCjDAT7ASO2wm4OCGQ
     */
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
