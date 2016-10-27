//
//  PromptText.m
//  XG
//
//  Created by deejan on 15/9/15.
//  Copyright (c) 2015年 memobird. All rights reserved.
//

#import "PromptText.h"
#import "PromptView.h"

#define kAnimationDuration 0.2
    //view高度
#define kViewHeight 56

@interface PromptText ()<UITextViewDelegate>

@property (assign, nonatomic) NSInteger limitCount;
@property (assign, nonatomic) NSInteger limitByteCount;
@property (assign, nonatomic) NSInteger textFlag;
@property (assign, nonatomic) NSInteger nData;

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *closeBt;
@property (strong, nonatomic) IBOutlet UILabel *tipLabel;
@property (strong, nonatomic) IBOutlet UITextView *textView;
@property (strong, nonatomic) IBOutlet UIButton *confirmBt;
@property (strong, nonatomic) IBOutlet UILabel *hintLabel;

@property (assign, nonatomic) CGFloat safeBottom;

@end

@implementation PromptText

- (void)awakeFromNib
{
    [super awakeFromNib];
    self.tipLabel.text = LOCALIZATION(@"请输入文字内容，支持普通文本和网址");
    self.limitCount = 0;
    self.limitByteCount = 0;
    self.textFlag = EPromptTextFlagNone;
    self.hintLabel.hidden = YES;
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    if (SCREEN_WIDTH != 320) {
        [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            make.top.mas_equalTo(self.textView.mas_top).with.offset(-3);
        }];
    }
//    [self.bgView setCornerRadius:5];
    if (SCREEN_HEIGHT==480) {
        [self.bgView mas_makeConstraints:^(MASConstraintMaker *make) {
            make.centerX.mas_equalTo(SCREEN_WIDTH/2);
            make.centerY.mas_equalTo(SCREEN_HEIGHT/2);
            make.height.mas_equalTo(@220);
        }];
    }
    UIImageView *closeImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
    closeImg.image = [UIImage imageNamed:@"close.png"];
    [self.closeBt addSubview:closeImg];
    
    self.confirmBt.backgroundColor = kProjectColorBlue;
    [self.confirmBt setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [self.confirmBt setCornerRadius:5];
    [self.textView setCornerRadius:5];
    [self.textView.layer setBorderColor:kProjectColorBlue.CGColor];
    [self.textView.layer setBorderWidth:1];
        //注册通知,监听键盘弹出事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
        //注册通知,监听键盘消失事件
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHidden) name:UIKeyboardDidHideNotification object:nil];
    [self.textView becomeFirstResponder];
}

- (void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}


+ (PromptText *)promptText{
    PromptText *obj = [PromptText loadFromNIB];
    return obj;
}

- (NSInteger)getNumOfRow{
    return self.textView.text.length/self.limitCount+1;
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    [self endEditing:YES];
}

- (void)setNData:(NSInteger)nData
{
    _nData = nData;
}

- (void)setText:(NSString *)text
{
    self.textFlag = EPromptTextFlagEdit;
    self.textView.text = text;
    self.tipLabel.hidden = self.textView.text.length>=1;
}

- (void)setTipText:(NSString *)tipText
{
    self.tipLabel.text = tipText;
}

- (void)limitCount:(NSInteger)limitCount
{
    if (limitCount<=0) {
        return;
    }
    self.limitCount = limitCount;
}

- (void)limitByteCount:(NSInteger)limitByteCount
{
    if (limitByteCount<=0) {
        return;
    }
    self.limitByteCount = limitByteCount;
}

- (void)btTitle:(NSString *)title
{
    [self.confirmBt setTitle:title forState:UIControlStateNormal];
}

- (void)show{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    self.backgroundColor = RGBA(0, 0, 0, .4);
    [vc.view addSubview:self];
}

-(void)keyboardDidShow:(NSNotification *)notification
{
        //获取键盘高度
    NSValue *keyboardObject = [[notification userInfo] objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect;
    [keyboardObject getValue:&keyboardRect];
    
    if (self.bgView.bottom<=(keyboardRect.origin.y+10)) {
        return;
    }
        //调整放置有textView的view的位置
        //设置动画
    [UIView beginAnimations:nil context:nil];
        //定义动画时间
    [UIView setAnimationDuration:kAnimationDuration];
        //设置view的frame，往上平移
    self.bgView.bottom = keyboardRect.origin.y+10;
    [UIView commitAnimations];
}

-(void)keyboardDidHidden
{
    if (self.bgView.center.y == SCREEN_HEIGHT/2) {
        return;
    }
        //定义动画
    [UIView beginAnimations:nil context:nil];
    [UIView setAnimationDuration:kAnimationDuration];
        //设置view的frame，往下平移
    self.bgView.top = SCREEN_HEIGHT/2-self.bgView.height/2;
    [UIView commitAnimations];
}

#pragma mark text view delegate

- (void)textViewDidChange:(UITextView *)textView
{
    self.tipLabel.hidden = textView.text.length > 0;
    NSString *hint = nil;
    NSInteger count = 0;
    NSInteger sum = 0;
    if (self.limitCount == 1500) {
        count = self.limitCount-textView.text.length;
    }else if (self.limitByteCount == 100){
        count = self.limitByteCount-[textView.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding];
    }
    if (count < 0) {
        count = 0;
        self.hintLabel.textColor = [UIColor redColor];
    }else{
        self.hintLabel.textColor = [UIColor blackColor];
    }
    if ( 0 != self.limitByteCount) {
        sum = self.limitByteCount;
    }else
        sum = self.limitCount;
    hint = [NSString stringWithFormat:@"%ld/%ld",(long)count,sum];
    self.hintLabel.text = hint;
}

#pragma mark 按钮响应

- (IBAction)closeBtClick:(id)sender {
    [self removeFromSuperview];
}

- (IBAction)confirmBtClick:(id)sender {
    
    if (self.limitCount != 0 && self.limitCount < self.textView.text.length) {
        
        NSString *limitStr = [NSString stringWithFormat:@"长度不能超过%ld个字数", (long)self.limitCount];
//        [PromptView promptView:limitStr confirmStr:@"确定" confirm:^{
//            
//        }];
        [[Toast makeText:limitStr] show];
        return;
    }
    
    if (0 != self.limitByteCount && self.limitByteCount < [self.textView.text lengthOfBytesUsingEncoding:NSUTF8StringEncoding]) {
//        NSString *limitStr = [NSString stringWithFormat:@"长度不能超过%ld个字母（数字）或33个汉字", (long)self.limitByteCount];
        NSString *limitStr = LOCALIZATION(@"长度不能超过100个字母（数字）或33个汉字");
//        [PromptView promptView:limitStr confirmStr:@"确定" confirm:^{
//            
//        }];
        [[Toast makeText:limitStr] show];
        return;
    }
    
    if (self.textBlock) {
        _textBlock(self.textView.text, self.textFlag, self.nData);
    }
    [self removeFromSuperview];
}

@end
