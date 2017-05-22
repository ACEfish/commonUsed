//
//  QRCodeAreaView.m
//  conductor
//
//  Created by 陈煌 on 16/6/24.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import "QRCodeAreaView.h"

@interface QRCodeAreaView()

@property (nonatomic, assign)CGPoint  position;/** 记录当前线条绘制的位置 */
@property (nonatomic, strong)NSTimer  *timer;/** 定时器 */

@end

@implementation QRCodeAreaView

- (void)drawRect:(CGRect)rect {
    
    CGPoint newPosition = self.position;
    newPosition.y += 1;
    
    //判断y到达底部，从新开始下降
    if (newPosition.y > rect.size.height) {
        newPosition.y = 0;
    }
    
    //重新赋值position
    self.position = newPosition;
    
    // 绘制图片
    UIImage *image = [self scaleToSize:[UIImage imageNamed:@"QR_line"] size:CGSizeMake(250, 20)];
    
    [image drawAtPoint:self.position];
    
}

- (instancetype)initWithFrame:(CGRect)frame{
    
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [UIColor clearColor];
        UIImageView *areaView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"QR_frame_icon"]];
        areaView.width = self.width;
        areaView.height = self.height;
        [self addSubview:areaView];
        self.timer = [NSTimer scheduledTimerWithTimeInterval:0.01 target:self selector:@selector(setNeedsDisplay) userInfo:nil repeats:YES];
    }
    
    return self;
}

- (void)startAnimaion{
    
    [self.timer setFireDate:[NSDate date]];
}

- (void)stopAnimaion{
    
    [self.timer setFireDate:[NSDate distantFuture]];
}


- (UIImage *)scaleToSize:(UIImage *)img size:(CGSize)newsize{
    
    UIGraphicsBeginImageContext(newsize);
    
    [img drawInRect:CGRectMake(0, 0, newsize.width, newsize.height)];
    
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    UIGraphicsEndImageContext();
    
    return scaledImage;
}


@end
