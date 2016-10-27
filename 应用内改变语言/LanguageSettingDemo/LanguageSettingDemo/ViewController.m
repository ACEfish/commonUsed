//
//  ViewController.m
//  LanguageSettingDemo
//
//  Created by 栗豫塬 on 16/7/21.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "ViewController.h"
#import "FSLanguageTool.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.navigationItem.title = FSGetStringWithKeyFromTable(@"RootTitle", @"Main");
    // Do any additional setup after loading the view, typically from a nib.
}
- (IBAction)change:(id)sender {
    [[FSLanguageTool sharedInstance] changeNowLanguage];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
