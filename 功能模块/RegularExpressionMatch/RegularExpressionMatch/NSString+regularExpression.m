//
//  NSString+regularExpression.m
//  RegularExpressionMatch
//
/**
 参考资料:https://my.oschina.net/u/2340880/blog/403638

 */
//  Created by 栗豫塬 on 16/10/27.
//  Copyright © 2016年 fish. All rights reserved.
//


#import "NSString+regularExpression.h"

#define regexp(reg, option) [NSRegularExpression regularExpressionWithPattern : reg options : option error : NULL]
/**
 typedef NS_OPTIONS(NSUInteger, NSRegularExpressionOptions) {
 NSRegularExpressionCaseInsensitive             = 1 << 0, //不区分字母大小写的模式
 NSRegularExpressionAllowCommentsAndWhitespace  = 1 << 1, //忽略掉正则表达式中的空格和#号之后的字符
 NSRegularExpressionIgnoreMetacharacters        = 1 << 2, //将正则表达式整体作为字符串处理
 NSRegularExpressionDotMatchesLineSeparators    = 1 << 3, //允许.匹配任何字符，包括换行符
 NSRegularExpressionAnchorsMatchLines           = 1 << 4, //允许^和$符号匹配行的开头和结尾
 NSRegularExpressionUseUnixLineSeparators       = 1 << 5, //设置\n为唯一的行分隔符，否则所有的都有效。
 NSRegularExpressionUseUnicodeWordBoundaries    = 1 << 6 //使用Unicode TR#29标准作为词的边界，否则所有传统正则表达式的词边界都有效
 };
 
 */

@implementation NSString (regularExpression)

//用谓词进行过滤(NSPredicate)
- (BOOL)evaluateWithExpress:(NSString *)express {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:express];
    return [predicate evaluateWithObject:self];
}

- (NSRange)filterWithExpress:(NSString *)express {
    NSRange range = [self rangeOfString:express options:NSRegularExpressionSearch];
    return range;
}

- (NSArray<NSString *> *)matchStringWithExpress:(NSString *)express options:(NSMatchingOptions)options {
    NSRegularExpression *regex = regexp(express,0);
   NSArray *resultArray = [regex matchesInString:self options:options range:NSMakeRange(0, self.length)];
    NSMutableArray *stringArray = [NSMutableArray array];
    for (NSTextCheckingResult *result in resultArray) {
        NSString *subString = [self substringWithRange:result.range];
        [stringArray addObject:subString];
    }
    return stringArray;
}



/**
 [regex enumerateMatchesInString:self options:NSMatchingReportCompletion range:NSMakeRange(0, 4) usingBlock:^(NSTextCheckingResult * _Nullable result, NSMatchingFlags flags, BOOL * _Nonnull stop) {
 
 }];
 */
























@end
