//
//  QYBook.m
//  06-XMLParseDemo
//
//  Created by qingyun on 15/12/17.
//  Copyright © 2015年 qingyun. All rights reserved.
//

#import "QYBook.h"

@implementation QYBook

- (NSString *)description {
    NSString *desc = [NSString stringWithFormat:@"BookInfo:\r  Title:<%@>\r  Language:<%@>\r  Category:<%@>\r  Author:<%@>\r  Year:<%@>\r  Price:<%@>\r  ", _title, _lang, _category, _author, _year, _price];
    return desc;
}

@end
