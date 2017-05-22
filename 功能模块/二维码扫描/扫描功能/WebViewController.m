//
//  WebViewController.m
//  conductor
//
//  Created by 陈煌 on 16/6/24.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import "WebViewController.h"

@interface WebViewController ()

@end

@implementation WebViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    UIWebView* webView = [[UIWebView alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT)];
    
    webView.scalesPageToFit = YES;

    [self.view addSubview:webView];
    
    NSURL* url = [NSURL URLWithString:self.URL];
    NSURLRequest* request = [NSURLRequest requestWithURL:url];
    [webView loadRequest:request];

}



@end
