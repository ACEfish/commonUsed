//
//  PromptView.m
//  XG
//
//  Created by chenjoy on 15/8/29.
//  Copyright (c) 2015年 memobird. All rights reserved.
//

#import "PromptView.h"

@interface PromptView ()
@property (strong, nonatomic) IBOutlet UIButton *closeBt;

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UILabel *title;
@property (weak, nonatomic) IBOutlet UIButton *confirmBt;
@property (weak, nonatomic) IBOutlet UIButton *cancelBt;

- (void)haveCancelBt:(BOOL)bHave;

@end

@implementation PromptView

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    UIImageView *closeImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
    closeImg.image = [UIImage imageNamed:@"close.png"];
    [self.closeBt addSubview:closeImg];
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.bgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    [self.bgView setCornerRadius:5];
    
    self.title.textColor = kProjectColorBlue;
    
    [self.confirmBt setCornerRadius:5];
    self.confirmBt.backgroundColor = kProjectColorBlue;
    [self.confirmBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [self.cancelBt setCornerRadius:5];
    self.cancelBt.backgroundColor = kProjectColorBlue;
    [self.cancelBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
}

+ (PromptView *)promptView:(NSString *)title
                confirmStr:(NSString *)confirmStr
                   confirm:(PromptConfirmBlock)confirmBlock
{
    PromptView *promptView = [PromptView promptView:title confirmStr:confirmStr confirm:confirmBlock cancelStr:nil cancel:nil];
    [promptView haveCancelBt:NO];
    return promptView;
}

+ (PromptView *)promptView:(NSString *)title
                confirmStr:(NSString *)confirmStr
                   confirm:(PromptConfirmBlock)confirmBlock
                 cancelStr:(NSString *)cancelStr
                    cancel:(PromptCancelBlock)cancelBlock
{
    PromptView *promptView = [PromptView loadFromNIB];
    promptView.title.text = title;
    promptView.title.adjustsFontSizeToFitWidth = YES;
    [promptView.confirmBt setTitle:confirmStr forState:UIControlStateNormal];
    promptView.confirmBlock = confirmBlock;
    [promptView.cancelBt setTitle:cancelStr forState:UIControlStateNormal];
    promptView.cancelBlock = cancelBlock;
    
    return promptView;
}

- (void)hideCloseBt
{
    self.closeBt.hidden = YES;
}

- (void)show
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    if ([UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController) {
        vc = [UIApplication sharedApplication].keyWindow.rootViewController.presentedViewController;
    }
    self.backgroundColor = RGBA(0, 0, 0, .4);
    [vc.view addSubview:self];
}

#pragma mark bt click

- (IBAction)closeBtClick:(id)sender {
    if (self.closeBlock) {
        _closeBlock();
    }
    [self removeFromSuperview];
}

- (IBAction)confirmClick:(id)sender {
    if (self.confirmBlock) {
        _confirmBlock();
    }
    [self removeFromSuperview];
}

- (IBAction)cancelClick:(id)sender {
    if (self.cancelBlock) {
        _cancelBlock();
    }
    [self removeFromSuperview];
}

#pragma mark privite func

- (void)haveCancelBt:(BOOL)bHave
{
    if (!bHave) {
        self.cancelBt.hidden = YES;
        self.bgView.height = 170;
        self.bgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    }
}

@end
