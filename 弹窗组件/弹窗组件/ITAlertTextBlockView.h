//
//  ITAlertTextBlockView.h
//  弹窗组件
//
//  Created by 栗豫塬 on 16/12/6.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>


typedef void(^AlertTextBlock)(NSString *name);

@interface ITAlertTextBlockView : UIView

@property (nonatomic, assign) NSInteger minLength;
@property (nonatomic, assign) NSInteger maxLength;


+ (instancetype)showWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                  placeholder:(NSString *)placeholde
               cancelBtnTitle:(NSString *)cancelBtnTitle
                        cancelBlock:(AlertTextBlock) cancelBlock
                 sureBtnTitle:(NSString *)sureBtnTitle
                    sureBlock:(AlertTextBlock) sureBlock;





@end
