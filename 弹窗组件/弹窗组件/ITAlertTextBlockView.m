//
//  ITAlertTextBlockView.m
//  弹窗组件
//
//  Created by 栗豫塬 on 16/12/6.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "Masonry.h"
#import "ITAlertTextBlockView.h"

#define kTitleBottomMargin 10
#define kSubTitleBottomMargin 30

@interface ITAlertTextBlockView ()


@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;
@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLabelMargin;


@property (nonatomic, copy) AlertTextBlock cancelBlock;
@property (nonatomic, copy) AlertTextBlock sureBlock;

@end


@implementation ITAlertTextBlockView

+ (instancetype)showWithTitle:(NSString *)title
                     subTitle:(NSString *)subTitle
                  placeholder:(NSString *)placeholde
               cancelBtnTitle:(NSString *)cancelBtnTitle
                  cancelBlock:(AlertTextBlock)cancelBlock
                 sureBtnTitle:(NSString *)sureBtnTitle
                    sureBlock:(AlertTextBlock)sureBlock {
    
    ITAlertTextBlockView *alertView = [[NSBundle mainBundle] loadNibNamed:[self description] owner:self options:nil][0];
    [[NSNotificationCenter defaultCenter] addObserver:alertView selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [alertView configWithTitle:title subTitle:subTitle
                   placeholder:placeholde
                cancelBtnTitle:cancelBtnTitle
                   cancelBlock:cancelBlock
                  sureBtnTitle:sureBtnTitle
                     sureBlock:sureBlock];
    [alertView show];
    return alertView;
}

- (void)configWithTitle:(NSString *)title
               subTitle:(NSString *)subTitle
            placeholder:(NSString *)placeholde
         cancelBtnTitle:(NSString *)cancelBtnTitle
            cancelBlock:(AlertTextBlock)cancelBlock
           sureBtnTitle:(NSString *)sureBtnTitle
              sureBlock:(AlertTextBlock)sureBlock  {
    self.cancelBlock = cancelBlock;
    self.sureBlock = sureBlock;
    
    self.titleLabel.text = title;
    if (subTitle) {
        self.subTitleLabel.text = subTitle;
    }
    [self.cancelBtn setTitle:(cancelBtnTitle ? cancelBtnTitle : @"取消") forState:UIControlStateNormal];
    [self.sureBtn setTitle:(sureBtnTitle ? sureBtnTitle : @"确定") forState:UIControlStateNormal];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
    if (placeholde) {
        self.textField.placeholder = placeholde;
    }
    
    
    [self.bgView.layer setMasksToBounds:YES];
    [self.bgView.layer setCornerRadius:10];
    
    self.maxLength = 0;
    //self.minLength = 0;
    [self.textField addTarget:self action:@selector(textFieldChange:) forControlEvents:UIControlEventEditingChanged];
}


- (void)layoutSubviews {
    [super layoutSubviews];
    if (!self.subTitleLabel.text && self.subTitleLabel.text.length == 0) {
        self.titleLabelMargin.constant = kTitleBottomMargin;
    } else {
        self.titleLabelMargin.constant = kTitleBottomMargin + self.subTitleLabel.frame.size.height + kSubTitleBottomMargin;
        
    }
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - event -

- (void)textFieldChange:(UITextField *)textField {
    self.maxLength = self.maxLength == 0 ? 15 : self.maxLength;
    if (textField.text.length > self.maxLength) {
        [textField endEditing:YES];
        textField.text = [textField.text substringToIndex:self.maxLength];
     //   [self makeToast:[NSString stringWithFormat:@"最多输入%ld位",self.maxLength]];
    }
    
}


- (void)cancelBtnClick {
    [self hideWithComplection:self.cancelBlock];
}

- (void)sureBtnClick {
    if (self.textField.text.length == 0 && (!self.textField.placeholder || self.textField.placeholder.length == 0)) {
        //
        [self.textField endEditing:YES];
     //   [self makeToast:@"内容不能为空"];
        return;
    }
    [self hideWithComplection:self.sureBlock];
}


- (void)show {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, 0, screenW, screenH);
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.bgView.alpha = 0;
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [self.textField becomeFirstResponder];
    [UIView animateWithDuration:0.5 animations:^{
        self.bgView.alpha = 1;
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideWithComplection:(AlertTextBlock)btnBlock {
    [self.textField endEditing:YES];
    NSString *content = @"";
    if (self.textField.text.length > 0) {
        content = self.textField.text;
    } else if(self.textField.placeholder.length > 0) {
        content = self.textField.placeholder;
    }
    
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (btnBlock) {
            btnBlock(content);
        }
    }];
    
}




#pragma mark - keyBoard -

- (void)keyboardWillShow:(NSNotification *)notification {
    CGFloat keyboardHeight = 0;
    CGFloat animationDuration = 0.3;
    UIInterfaceOrientation orientation = [[UIApplication sharedApplication] statusBarOrientation];
    
    if(notification) {
        NSDictionary* keyboardInfo = [notification userInfo];
        CGRect keyboardFrame = [[keyboardInfo valueForKey:UIKeyboardFrameBeginUserInfoKey] CGRectValue];
        animationDuration = [[keyboardInfo valueForKey:UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        
        if(UIInterfaceOrientationIsPortrait(orientation)) {
            keyboardHeight = keyboardFrame.size.height;
        } else {
            keyboardHeight = keyboardFrame.size.width;
        }
    }
    
    CGFloat screenHeight = 0;
    
    if(UIInterfaceOrientationIsPortrait(orientation))
        screenHeight = [UIScreen mainScreen].bounds.size.height;
    else
        screenHeight = [UIScreen mainScreen].bounds.size.width;
    
    
    __block CGRect frame = self.bgView.frame;
    
    //默认键盘高度为256，系统键盘高度为256，三方键盘一般为216
    keyboardHeight = 271;
    
    if (frame.origin.y + frame.size.height > screenHeight - keyboardHeight) {
        
        frame.origin.y = screenHeight - keyboardHeight - frame.size.height - 10;
        
        if (frame.origin.y < 0)
            frame.origin.y = 0;
        
        [UIView animateWithDuration:animationDuration
                              delay:0.0
                            options:UIViewAnimationCurveEaseOut | UIViewAnimationOptionBeginFromCurrentState
                         animations:^{
                             self.bgView.frame = frame;
                         }
                         completion:nil];
    }
    
}














@end
