//
//  ViewController.m
//  01-绘制箭头
//
//  Created by qingyun on 16/1/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "ViewController.h"
#import "AppDelegate.h"

@interface ViewController ()
@end

@implementation ViewController


- (IBAction)startAction:(UIButton *)sender {
    AppDelegate *app=[UIApplication sharedApplication].delegate;
   
    
    
    
    //1.开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.view.frame.size, NO, 1);
    
    //2.获取当前上下文
    CGContextRef ctx=UIGraphicsGetCurrentContext();
    
    //3.绘制
    [self.view.layer renderInContext:ctx];
    
    //4.取出图片，
    UIImage *currentImage=UIGraphicsGetImageFromCurrentImageContext();
    NSData *imageData=UIImagePNGRepresentation(currentImage);
    [imageData writeToFile:@"/Users/qingyun/Desktop/Screen.png" atomically:YES];
    
    //.关闭图形上下文
    UIGraphicsEndImageContext();
    
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
