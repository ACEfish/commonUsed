//
//  ViewController2.m
//  LanguageSettingDemo
//
//  Created by 栗豫塬 on 16/7/21.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "ViewController2.h"


@interface ViewController2 ()
@property (weak, nonatomic) IBOutlet UILabel *lab;

@end

@implementation ViewController2

- (void)viewDidLoad {
    [super viewDidLoad];
    self.lab.text = FSGetStringWithKeyFromTable(@"NowLanguage", @"Person");
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
