//
//  FSLanguageTool.h
//  LanguageSettingDemo
//
//  Created by 栗豫塬 on 16/7/21.
//  Copyright © 2016年 fish. All rights reserved.
//

#define FSGetStringWithKeyFromTable(key, tbl)  [[FSLanguageTool sharedInstance] getStringForKey:key withTable:tbl]


#import <Foundation/Foundation.h>

@interface FSLanguageTool : NSObject

+ (instancetype)sharedInstance;

/**
  *返回table中指定key的值
  *
  *@prama key key
  *@prama table table
  *
  *@return 返回table中指定key的值
  */
- (NSString *)getStringForKey:(NSString *)key withTable:(NSString *)table;

/**
  * 改变当前语言
  */
- (void)changeNowLanguage;

/**
  *设置新的语言
  *@prama language 新语言
  */
- (void)setNewLanguage:(NSString *)language;


@end
