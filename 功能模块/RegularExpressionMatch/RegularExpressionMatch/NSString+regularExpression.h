//
//  NSString+regularExpression.h
//  RegularExpressionMatch
//
//  Created by 栗豫塬 on 16/10/27.
//  Copyright © 2016年 fish. All rights reserved.
//

/**
     常用正则表达式:http://www.admin10000.com/document/5944.html
                http://www.jianshu.com/p/e7bb97218946
 */

#import <Foundation/Foundation.h>

@interface NSString (regularExpression)

- (BOOL)evaluateWithExpress:(NSString *)express;

- (NSRange)filterWithExpress:(NSString *)express;


/**
 @param options
 typedef NS_OPTIONS(NSUInteger, NSMatchingOptions) {
 NSMatchingReportProgress         = 1 << 0, //找到最长的匹配字符串后调用block回调
 NSMatchingReportCompletion       = 1 << 1, //找到任何一个匹配串后都回调一次block
 NSMatchingAnchored               = 1 << 2, //从匹配范围的开始出进行极限匹配
 NSMatchingWithTransparentBounds  = 1 << 3, //允许匹配的范围超出设置的范围
 NSMatchingWithoutAnchoringBounds = 1 << 4  //禁止^和$自动匹配行还是和结束
 };
 
 typedef NS_OPTIONS(NSUInteger, NSMatchingFlags) {
 NSMatchingProgress               = 1 << 0, //匹配到最长串是被设置
 NSMatchingCompleted              = 1 << 1, //全部分配完成后被设置
 NSMatchingHitEnd                 = 1 << 2, //匹配到设置范围的末尾时被设置
 NSMatchingRequiredEnd            = 1 << 3, //当前匹配到的字符串在匹配范围的末尾时被设置
 NSMatchingInternalError          = 1 << 4  //由于错误导致的匹配失败时被设置
 };
 */
- (NSArray<NSString *> *)matchStringWithExpress:(NSString *)express options:(NSMatchingOptions)options;

@end
