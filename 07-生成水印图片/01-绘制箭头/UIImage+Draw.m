//
//  UIImage+Draw.m
//  01-绘制箭头
//
//  Created by qingyun on 16/1/8.
//  Copyright © 2016年 qingyun. All rights reserved.
//

#import "UIImage+Draw.h"

@implementation UIImage (Draw)
-(UIImage *)waterImageWithLogo:(UIImage *)image{
   /**
    如果要创建一个图片，首先
    *开启图片上下文
    **/
    //1.开启图片上下文
    UIGraphicsBeginImageContextWithOptions(self.size, NO, 0);
    
    //2.画母版背景
    [self drawInRect:CGRectMake(0, 0, self.size.width, self.size.height)];
    
    //3.画水印
    CGFloat logx,logy,logwith,logheight;
    CGFloat scale=.2;
    CGFloat space=10;
    logx=self.size.width-image.size.width*scale-space;
    logy=self.size.height-image.size.height*scale-space;
    logwith=image.size.width *scale;
    logheight=image.size.height*scale;
    [image drawInRect:CGRectMake(logx, logy, logwith,logheight)];
    //4.从当前上下文获取图片
    UIImage *waterImage=UIGraphicsGetImageFromCurrentImageContext();
    
    //5.关闭上下文
    UIGraphicsEndImageContext();
    
    return waterImage;
}

@end
