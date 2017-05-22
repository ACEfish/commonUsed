//
//  ITSheetBlockView.h
//  弹窗组件
//
//  Created by 栗豫塬 on 16/12/6.
//  Copyright © 2016年 fish. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^SheetBtnBlock)();

@interface ITSheetBlockView : UIView

+ (instancetype) sheetWithCancelTitle:(NSString *)cancelTitle cancelBlock:(SheetBtnBlock)cancelBtnBlock;

- (void)addBtnTitle:(NSString *)btnTitle btnBlock:(SheetBtnBlock)btnBlock;

- (void)show;

@end
