//
//  FSLanguageTool.m
//  LanguageSettingDemo
//
//  Created by 栗豫塬 on 16/7/21.
//  Copyright © 2016年 fish. All rights reserved.
//

#define CNS @"zh-Hans"
#define EN @"en"
#define LANGUAGE_SET @"langeuageset"

#import "AppDelegate.h"
#import "FSLanguageTool.h"

static FSLanguageTool *sharedModel;

@interface FSLanguageTool ()

@property (nonatomic, strong) NSBundle *bundle;
@property (nonatomic, copy) NSString *language;

@end


@implementation FSLanguageTool

+ (instancetype)sharedInstance{
    if (!sharedModel) {
        sharedModel = [[FSLanguageTool alloc]init];
    }
    return sharedModel;
}

- (instancetype)init{
    if ( self = [super init]) {
        [self initLanguage];
    }
    return  self;
}

- (void)initLanguage {
    NSString *tmp = [[NSUserDefaults standardUserDefaults] objectForKey:LANGUAGE_SET];
    NSString *path;
    //默认中文
    if (!tmp) {
        tmp = CNS;
    }else {
        tmp = EN;
    }
    self.language = tmp;
    path = [[NSBundle mainBundle]pathForResource:self.language ofType:@"lproj"];
    self.bundle = [NSBundle bundleWithPath:path];
    
}

- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table{
    if (self.bundle) {
        return NSLocalizedStringFromTableInBundle(key, table, self.bundle, @"");
    }
    return NSLocalizedStringFromTable(key, table, @"");
}

- (void)changeNowLanguage{
    if ([self.language isEqualToString:EN]) {
        [self setNewLanguage:CNS];
    }else {
        [self setNewLanguage:EN];
    }
}

- (void)setNewLanguage:(NSString *)language{
    if ([language isEqualToString:self.language]) {
        return;
    }
    if ([language isEqualToString:EN] || [language isEqualToString:CNS]) {
        NSString *path = [[NSBundle mainBundle] pathForResource:language ofType:@"lproj"];
        self.bundle = [NSBundle bundleWithPath:path];
    }
    self.language = language;
    
    
    [[NSUserDefaults standardUserDefaults] setObject:language forKey:LANGUAGE_SET];
    [[NSUserDefaults standardUserDefaults] synchronize];
    [self resetRootViewController];
}

- (void)resetRootViewController {
    AppDelegate *appDelegate =
    (AppDelegate *)[[UIApplication sharedApplication] delegate];
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    UINavigationController *rootNav = [storyBoard instantiateViewControllerWithIdentifier:@"rootnav"];
    UINavigationController *personNav = [storyBoard instantiateViewControllerWithIdentifier:@"personnav"];
    UITabBarController *tabVC = (UITabBarController*)appDelegate.window.rootViewController;
    tabVC.viewControllers = @[rootNav,personNav];
}


@end
