//
//  PromptImage.m
//  XG
//
//  Created by chenjoy on 15/9/13.
//  Copyright (c) 2015年 memobird. All rights reserved.
//

#import "PromptImage.h"

@interface PromptImage ()

@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (weak, nonatomic) IBOutlet UIButton *closeBt;
@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UILabel *label1;
@property (weak, nonatomic) IBOutlet UILabel *label2;

@end

@implementation PromptImage

- (void)awakeFromNib{
    [super awakeFromNib];
    
    UIImageView *closeImg = [[UIImageView alloc] initWithFrame:CGRectMake(15, 5, 20, 20)];
    closeImg.image = [UIImage imageNamed:@"close.png"];
    [self.closeBt addSubview:closeImg];
    self.imageView.frame = CGRectMake(65, 65, 150, 150);
    self.imageView.image = [UIImage imageNamed:@"scan_qr.png"];
    self.label1.textColor = kProjectColorBlue;
    self.label2.textColor = kProjectColorBlue;
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.bgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
    
    self.label1.text = LOCALIZATION(@"双击按键");
    self.label2.text = LOCALIZATION(@"扫一扫纸条二维码来绑定");
}

+ (PromptImage *)promptImage
{
    PromptImage *obj = [PromptImage loadFromNIB];
    
    return obj;
}

+ (PromptImage *)promptImage:(NSString *)imageStr tipFirst:(NSString *)tip1 tipSecond:(NSString *)tip2
{
    PromptImage *obj = [PromptImage promptImage];

    return obj;
}


- (void)changeImage:(NSString *)imgStr
{
    if (nil == imgStr) {
        return;
    }
    self.imageView.image = [UIImage imageNamed:imgStr];
}

- (void)changeTip:(NSString *)tip1 tipSecond:(NSString *)tip2
{
    self.label1.text = tip1;
    self.label2.text = tip2;
}

- (void)changePic{
    [self.imageView setImage:[UIImage imageNamed:@"press_btn"]];
    self.label1.text = @"长按按键6秒";
    self.label2.text = @"进入wifi智能配置模式";
}

- (void)show
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    self.backgroundColor = RGBA(0, 0, 0, .4);
    [vc.view addSubview:self];
}


- (IBAction)closeBtClick:(id)sender {
    if (self.closeBlock) {
        _closeBlock();
    }
    [self removeFromSuperview];
}

@end
