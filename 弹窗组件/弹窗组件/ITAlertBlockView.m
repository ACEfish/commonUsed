//
//  ITAlertBlockView.m
//  弹窗组件
//
//  Created by 栗豫塬 on 16/12/6.
//  Copyright © 2016年 fish. All rights reserved.
//


#define kTitleBottomMargin 30
#define kSubTitleBottomMargin 40

#import "ITAlertBlockView.h"

@interface ITAlertBlockView ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleMargin;

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

@property (weak, nonatomic) IBOutlet UILabel *subTitleLabel;

@property (weak, nonatomic) IBOutlet UIButton *cancelBtn;

@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (weak, nonatomic) IBOutlet UIButton *bottomBtn;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIView *centerSeperateView;

@property (nonatomic, copy) AlertBtnBlock sureBtnBlock;
@property (nonatomic, copy) AlertBtnBlock cancelBtnBlock;

@end



@implementation ITAlertBlockView


+ (void)showWithTitle:(NSString *)title subTitle:(NSString *)subTitle
       cancleBtnTitle:(NSString *)cancleBtnTitle
       cancleBtnBlock:(AlertBtnBlock)btnBlock {
    ITAlertBlockView *alertView = [[NSBundle mainBundle] loadNibNamed:[self description] owner:self options:nil][0];
    alertView.titleLabel.text = title;
    alertView.subTitleLabel.text = subTitle;
    alertView.sureBtn.hidden = YES;
    alertView.cancelBtn.hidden = YES;
    alertView.centerSeperateView.hidden = YES;
    if (cancleBtnTitle) {
        [alertView.bottomBtn setTitle:cancleBtnTitle forState:UIControlStateNormal];
    }
    if (btnBlock) {
        alertView.cancelBtnBlock = btnBlock;
    }
    [alertView show];
}

+ (void)showWithTitle:(NSString *)title subTitle:(NSString *)subTitle
         sureBtnTitle:(NSString *)sureBtnTitle
         sureBtnBlock:(AlertBtnBlock)surebtnBlock
       cancleBtnTitle:(NSString *)cancleBtnTitle
       cancleBtnBlock:(AlertBtnBlock)canclebtnBlock {
    ITAlertBlockView *alertView = [[NSBundle mainBundle] loadNibNamed:[self description] owner:self options:nil][0];
    alertView.titleLabel.text = title;
    alertView.subTitleLabel.text = subTitle;
    alertView.bottomBtn.hidden = YES;
    if (sureBtnTitle) {
        [alertView.sureBtn setTitle:sureBtnTitle forState:UIControlStateNormal];
    }
    if (cancleBtnTitle) {
        [alertView.cancelBtn setTitle:cancleBtnTitle forState:UIControlStateNormal];
    }
    if (surebtnBlock) {
        alertView.sureBtnBlock = surebtnBlock;
    }
    if (canclebtnBlock) {
        alertView.cancelBtnBlock = canclebtnBlock;
    }
    [alertView show];
}


#pragma mark - 初始化视图 -

- (void)awakeFromNib {
    [super awakeFromNib];
    [self.bgView.layer setMasksToBounds:YES];
    [self.bgView.layer setCornerRadius:10];
    
    
    [self.bottomBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [self.sureBtn addTarget:self action:@selector(sureBtnClick) forControlEvents:UIControlEventTouchUpInside];
    
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    if (!self.subTitleLabel.text) {
        self.titleMargin.constant = kTitleBottomMargin;
    } else {
        self.titleMargin.constant = kTitleBottomMargin + self.subTitleLabel.frame.size.height + kSubTitleBottomMargin;
    }
}


#pragma mark - event -

- (void)sureBtnClick {
    [self hideWithComplection:self.sureBtnBlock];
}

- (void)cancelBtnClick {
    [self hideWithComplection:self.cancelBtnBlock];
}


- (void)show {
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    self.bgView.alpha = 0;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, 0, screenW, screenH);
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    [UIView animateWithDuration:0.5 animations:^{
       self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.bgView.alpha = 1;
    } completion:^(BOOL finished) {
        
    }];
}

- (void)hideWithComplection:(AlertBtnBlock)btnBlock {
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (btnBlock) {
            btnBlock();
        }
    }];
}


@end
