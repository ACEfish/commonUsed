//
//  PromptImage.h
//  XG
//
//  Created by chenjoy on 15/9/13.
//  Copyright (c) 2015年 memobird. All rights reserved.
//

#import <UIKit/UIKit.h>

//图片提示框

typedef void (^PromptImageCloseBlock)(void);

@interface PromptImage : UIView

@property (nonatomic, copy) PromptImageCloseBlock closeBlock;

+ (PromptImage *)promptImage;
+ (PromptImage *)promptImage:(NSString *)imageStr tipFirst:(NSString *)tip1 tipSecond:(NSString *)tip2;

- (void)changeImage:(NSString *)imgStr;
- (void)changeTip:(NSString *)tip1 tipSecond:(NSString *)tip2;

- (void)changePic;
- (void)show;

@end
