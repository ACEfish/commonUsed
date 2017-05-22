//
//  ViewController.m
//  GCD定时器
//
//  Created by 栗豫塬 on 16/10/28.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "ViewController.h"
#import "GCDTimer.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [[GCDTimer timer] dispatchTimerWithName:@"time" timeInterval:1 queue:nil repeat:YES action:^{
        NSLog(@"这是一条log日志");
    }];
    
    
    // Do any additional setup after loading the view, typically from a nib.
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
