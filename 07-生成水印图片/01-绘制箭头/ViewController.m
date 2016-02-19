//
//  ViewController.m
//  01-绘制箭头
//
//  Created by qingyun on 16/1/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import "UIImage+Draw.h"

@interface ViewController ()
@end

@implementation ViewController


- (IBAction)startAction:(UIButton *)sender {
    //1母版image
    UIImage *modeImage=[UIImage imageNamed:@"pic.jpg"];
    //2.logoImage
    UIImage *logoImage=[UIImage imageNamed:@"logo.jpg"];
    
    //3生成水印图片
    UIImage *waterImage=[modeImage waterImageWithLogo:logoImage];
    NSData *data=UIImagePNGRepresentation(waterImage);
 
    //存在本地
    [data writeToFile:@"/Users/qingyun/Desktop/water.png" atomically:YES];
    
    
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
