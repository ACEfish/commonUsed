//
//  PromptText.h
//  XG
//
//  Created by deejan on 15/9/15.
//  Copyright (c) 2015年 memobird. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EPromptTextFlagType)
{
    EPromptTextFlagNone = 0,//无
    EPromptTextFlagEdit     //编辑旧内容
};

typedef void(^PromptTextBlock) (NSString *text, NSInteger flag, NSInteger nData);

@interface PromptText : UIView

@property (nonatomic, copy) PromptTextBlock textBlock;

+ (PromptText *) promptText;

- (NSInteger)getNumOfRow;

- (void)setNData:(NSInteger)nData;

- (void)setText:(NSString *)text;
- (void)setTipText:(NSString *)tipText;
    //字数限制
- (void)limitCount:(NSInteger)limitCount;
    //字节数限制
- (void)limitByteCount:(NSInteger)limitByteCount;

- (void)btTitle:(NSString *)title;

- (void) show;

@end
