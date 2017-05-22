//
//  TLContact.m
//  conductor
//
//  Created by 陈煌 on 16/6/2.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import "TLContact.h"

@implementation TLContact

- (NSString *)pinyin
{
    if (_pinyin == nil) {
        _pinyin = self.name.pinyin;
    }
    return _pinyin;
}

- (NSString *)pinyinInitial
{
    if (_pinyinInitial == nil) {
        _pinyinInitial = self.name.pinyinInitial;
    }
    return _pinyinInitial;
}
@end
