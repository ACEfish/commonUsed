//
//  ViewController.m
//  弹窗组件
//
//  Created by 栗豫塬 on 16/12/6.
//  Copyright © 2016年 fish. All rights reserved.
//



#import "ViewController.h"

#import "ITAlertBlockView.h"
#import "ITSheetBlockView.h"
#import "ITAlertTextBlockView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)alertShow2:(id)sender {
    [ITAlertBlockView showWithTitle:@"标题" subTitle:nil sureBtnTitle:@"确定" sureBtnBlock:^{
        NSLog(@"确定");
    } cancleBtnTitle:nil cancleBtnBlock:^{
        NSLog(@"取消");
    }];
}

- (IBAction)alertShow:(id)sender {
    [ITAlertBlockView showWithTitle:@"标题" subTitle:@"副标题" cancleBtnTitle:@"取消" cancleBtnBlock:^{
        NSLog(@"取消");
    }];
    
}
- (IBAction)sheetShow:(id)sender {
    ITSheetBlockView *sheetView = [ITSheetBlockView sheetWithCancelTitle:@"标题" cancelBlock:^{
        NSLog(@"quxiao ");
    }];
    [sheetView addBtnTitle:@"相册" btnBlock:^{
        NSLog(@"相册");
    }];
    [sheetView addBtnTitle:@"照片" btnBlock:^{
        NSLog(@"照片");
    }];
    [sheetView show];
}

- (IBAction)textSHow:(id)sender {
    [ITAlertTextBlockView showWithTitle:@"标题" subTitle:@"副标题" placeholder:@"placeaaaa" cancelBtnTitle:nil cancelBlock:^(NSString *name) {
        NSLog(@"取消");
    } sureBtnTitle:@"保存" sureBlock:^(NSString *name) {
        NSLog(@"%@",name);
    }];
}



@end
