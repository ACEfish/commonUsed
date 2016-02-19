//
//  FSSliderView.m
//  viewText
//
//  Created by qingyun on 16/1/16.
//  Copyright © 2016年 qingyun.com. All rights reserved.
//

#import "FSSliderView.h"
#import "Masonry.h"

@interface FSSliderView ()

@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *midView;
@property (nonatomic, strong) UIView *rightView;


@end


@implementation FSSliderView


// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    [self initTheView];
}

- (void)initTheView{
    _leftView = [[UIView alloc]init];
    _rightView = [[UIView alloc]init];
    _midView = [[UIView alloc]init];
    
    _leftView.backgroundColor = [UIColor redColor];
    _midView.backgroundColor = [UIColor blueColor];
    _rightView.backgroundColor = [UIColor greenColor];
    
    [self addSubview:_leftView];
    [self addSubview:_rightView];
    [self addSubview:_midView];
    
    UIPanGestureRecognizer *panGesture = [[UIPanGestureRecognizer alloc]initWithTarget:self action:@selector(panGesture:)];
    [self addGestureRecognizer:panGesture];
    
    [self setLayOut];
   }


- (void)setLayOut{
    
    [self.leftView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerY.equalTo(@[self,self.rightView,self.midView]);
        make.width.equalTo(@[self,self.rightView,self.midView]);
        make.height.equalTo(@[self,self.rightView,self.midView]);
        make.right.equalTo(self.midView.mas_left);
    }];
    [self.midView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.centerX.equalTo(self.mas_centerX);
    }];
    [self.rightView mas_remakeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.midView.mas_right);
        //make.width.equalTo(@[self]);
       // make.height.equalTo(@[self]);
    }];
    
    
  
    
}

- (void)setMidViewLocation:(NSInteger )location{
    [self.midView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.center.equalTo(self.mas_centerX).with.offset(location);
    }];
}

- (void)panGesture:(UIPanGestureRecognizer *)panGesture{
    
    
    CGPoint transtion = [panGesture translationInView:self.midView];
    CGFloat offset = transtion.x;
    //    if (panGesture.state == UIGestureRecognizerStateBegan) {
    //
    //    }
    NSLog(@"%f",offset);
    [self setMidViewLocation:offset];
    if (panGesture.state == UIGestureRecognizerStateEnded) {
        if ( self.midView.center.x>=self.frame.size.width) {
            [UIView animateWithDuration: (self.frame.size.width - self.midView.frame.origin.x)/500 animations:^{
                [self setMidViewLocation:self.frame.size.width];
                [self layoutIfNeeded];
            }completion:^(BOOL finished) {
                [self cutLefView];
            }];
            
            
        }else if(self.midView.center.x<=0){
            [UIView animateWithDuration: (self.frame.size.width + self.midView.frame.origin.x)/500 animations:^{
                 [self setMidViewLocation: -self.frame.size.width];
                [self layoutIfNeeded];
            }completion:^(BOOL finished) {
                 [self cutRightView];
            }];
           
        }else {
            [UIView animateWithDuration:self.midView.frame.origin.x/500 animations:^{
                [self setMidViewLocation: 0];
                [self layoutIfNeeded];
            }];
            
        }
        
    }
}


- ( void)cutLefView{
    NSLog(@"left");
    [self setLeftLayout];
}

- (void)setLeftLayout{
    UIView *mid = self.midView;
    UIView *left = self.leftView;
    UIView *right = self.rightView;
    self.midView = left;
    self.rightView = mid;
    self.leftView = right;
    [self setLayOut];
    
}



- (void)cutRightView{
    NSLog(@"right");
    UIView *mid = self.midView;
    UIView *left = self.leftView;
    UIView *right = self.rightView;
    
    self.midView = right;
    self.leftView = mid;
    self.rightView = left;
    [self setLayOut];

}


@end
