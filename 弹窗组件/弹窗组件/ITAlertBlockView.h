//
//  ITAlertBlockView.h
//  弹窗组件
//
//  Created by 栗豫塬 on 16/12/6.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^AlertBtnBlock)();

@interface ITAlertBlockView : UIView

+ (void)showWithTitle:(NSString *)title subTitle:(NSString *)subTitle
       cancleBtnTitle:(NSString *)cancleBtnTitle
       cancleBtnBlock:(AlertBtnBlock)btnBlock;

+ (void)showWithTitle:(NSString *)title subTitle:(NSString *)subTitle
       sureBtnTitle:(NSString *)sureBtnTitle
       sureBtnBlock:(AlertBtnBlock)surebtnBlock
       cancleBtnTitle:(NSString *)cancleBtnTitle
       cancleBtnBlock:(AlertBtnBlock)canclebtnBlock;



@end
