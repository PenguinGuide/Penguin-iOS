//
//  ViewController.m
//  PenguinGuide
//
//  Created by Jing Dai on 6/27/16.
//  Copyright © 2016 Xinglian. All rights reserved.
//

#import "ViewController.h"
#import "PGRouter.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.view.backgroundColor = [UIColor whiteColor];
    
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
