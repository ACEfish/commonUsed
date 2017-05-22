//
//  ViewController.m
//  实时改变textView高度
//
//  Created by 栗豫塬 on 16/10/28.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITextViewDelegate>

@property (nonatomic, strong) UITextView *contentTextView;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    // 下面这一段代码，笔者就不费口舌了，读者应该都看的懂，就是创建一个外观类似于UITextField的UITextView
    self.contentTextView = [[UITextView alloc]initWithFrame:CGRectMake(([UIScreen mainScreen].bounds.size.width-250)/2, [UIScreen mainScreen].bounds.size.height/2-50, 250, 39)];
    self.contentTextView .layer.cornerRadius = 4;
    self.contentTextView .layer.masksToBounds = YES;
    self.contentTextView .delegate = self;
    self.contentTextView .layer.borderWidth = 1;
    self.contentTextView .font = [UIFont systemFontOfSize:14];
    self.contentTextView .layer.borderColor = [[[UIColor lightGrayColor] colorWithAlphaComponent:0.4] CGColor];
    //加下面一句话的目的是，是为了调整光标的位置，让光标出现在UITextView的正中间
    self.contentTextView.textContainerInset = UIEdgeInsetsMake(10,0, 0, 0);
    [self.view addSubview:self.contentTextView ];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(changeFrame) name:UITextViewTextDidChangeNotification object:nil];

}

/**
    计算输入文字高度的方法,之所以返回的高度值加22是因为UITextView有一个初始的高度值40，但是输入第一行文字的时候文字高度只有18，所以UITextView的高度会发生变化，效果不太好
 */
- (float) heightForTextView: (UITextView *)textView WithText: (NSString *) strText{
    CGSize constraint = CGSizeMake(textView.contentSize.width , CGFLOAT_MAX);
    CGRect size = [strText boundingRectWithSize:constraint
                                        options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
                                     attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}
                                        context:nil];
    float textHeight = size.size.height + 22.0;
    return textHeight;
}

- (void)changeFrame {
    CGRect frame = self.contentTextView.frame;
    float  height = [ self heightForTextView:self.contentTextView WithText:self.contentTextView.text];
    frame.size.height = height;
    [UIView animateWithDuration:0.5 animations:^{
        
        self.contentTextView.frame = frame;
        
    } completion:nil];
}

//- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text
//{
//    
//    
//    return YES;
//}


@end
