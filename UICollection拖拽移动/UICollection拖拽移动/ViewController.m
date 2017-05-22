//
//  ViewController.m
//  UICollection拖拽移动
//
//  Created by 栗豫塬 on 17/1/4.
//  Copyright © 2017年 fish. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UICollectionViewDelegate, UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSIndexPath *originIndexPath;
@property (nonatomic, strong) UICollectionViewCell *originCell;

@end

@implementation ViewController

static NSString *indentifier = @"identifier";

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(50, 50);
    UICollectionView *collectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0, 64, self.view.bounds.size.width, self.view.bounds.size.height) collectionViewLayout:layout];
    layout.minimumLineSpacing = 10;
    layout.minimumInteritemSpacing = 10;
    [collectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:indentifier];
    collectionView.dataSource = self;
    collectionView.delegate = self;
    //此处给其增加长按手势，用此手势触发cell移动效果
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    [collectionView addGestureRecognizer:longGesture];
    [self.view addSubview:collectionView];
    self.collectionView = collectionView;
    
    
   
}


#if __IPHONE_OS_VERSION_MAX_ALLOWED >= __IPHONE_9_0

#pragma mark - IOS 9以后 -

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    
    //获取此次点击的坐标，根据坐标获取cell对应的indexPath
    CGPoint point = [longPress locationInView:_collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:point];
    //根据长按手势的状态进行处理。
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan:
            //当没有点击到cell的时候不进行处理
            if (!indexPath) {
                break;
            }
            //开始移动
            [_collectionView beginInteractiveMovementForItemAtIndexPath:indexPath];
             [self startAnimation];
            break;
            
        case UIGestureRecognizerStateChanged:
            //移动过程中更新位置坐标
            [_collectionView updateInteractiveMovementTargetPosition:point];
            break;
            
        case UIGestureRecognizerStateEnded:
            //停止移动调用此方法
            [_collectionView endInteractiveMovement];
            [self stopAnimation];
            break;
            
        default:
            //取消移动
            [_collectionView cancelInteractiveMovement];
            break;
    }
    
}
- (BOOL)collectionView:(UICollectionView *)collectionView canMoveItemAtIndexPath:(NSIndexPath *)indexPath {//如果都可以移动，直接就返回YES ,不能移动的返回NO
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView moveItemAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath*)destinationIndexPath {
 
    
  
    
}

#else

#pragma mark - IOS 9以前 -

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress {
    
    //获取此次点击的坐标，根据坐标获取cell对应的indexPath
    CGPoint point = [longPress locationInView:_collectionView];
    NSIndexPath *cellIndexpath = [self.collectionView indexPathForItemAtPoint:point];
    
    //根据长按手势的状态进行处理。
    switch (longPress.state) {
        case UIGestureRecognizerStateBegan: {
            if (!cellIndexpath) {
                return;
            }
            UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:cellIndexpath];
            //将此cell 移动到视图的前面
            [self.collectionView bringSubviewToFront:cell];
            self.originIndexPath = cellIndexpath;
            self.originCell = cell;
        }
            break;
        case UIGestureRecognizerStateChanged: {
            //在移动过程中，使cell的中心与移动的位置相同。
            self.originCell.center = [longPress locationInView:_collectionView];

            if ( cellIndexpath && cellIndexpath != self.originIndexPath) {
#warning 改变数据源
                [self.collectionView moveItemAtIndexPath:self.originIndexPath toIndexPath:cellIndexpath];
                self.originIndexPath = cellIndexpath;
            }
        }
            
            break;
        case UIGestureRecognizerStateEnded: {
            self.originCell.center = [self.collectionView layoutAttributesForItemAtIndexPath:self.originIndexPath].center;
        }
            
            break;
            
        default:
        {
            self.originCell.center = [self.collectionView layoutAttributesForItemAtIndexPath:self.originIndexPath].center;
        }
            break;
    }
}

#endif

#pragma mark - 震动动画 -

- (void)startAnimation {
    for (int i = 0; i < 30; i++) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        
        CABasicAnimation *rotateAnimation = [CABasicAnimation animationWithKeyPath:@"transform.rotation.z"];
        rotateAnimation.duration = 0.1;
        rotateAnimation.repeatCount = MAXFLOAT;
        rotateAnimation.fromValue = [NSNumber numberWithFloat:-M_1_PI/2];
        rotateAnimation.toValue = [NSNumber numberWithFloat:M_1_PI/2];
        rotateAnimation.autoreverses = YES;
        cell.layer.anchorPoint = CGPointMake(0.5, 0.5);
        [cell.layer addAnimation:rotateAnimation forKey:@"rotate-layer"];
        
    }
}


- (void)stopAnimation {
    for (int i = 0; i < 30; i++) {
        UICollectionViewCell *cell = [self.collectionView cellForItemAtIndexPath:[NSIndexPath indexPathForRow:i inSection:0]];
        [cell.layer removeAllAnimations];
    }
}

# pragma mark - UICollectionViewDelegate -

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return 30;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:indentifier forIndexPath:indexPath];
    cell.backgroundColor = [UIColor blueColor];
    UILabel *titleLabel = [[UILabel alloc] init];
    titleLabel.text = @(indexPath.row).stringValue;
    titleLabel.frame = CGRectMake(0, 0, 30, 20);
    [cell addSubview:titleLabel];
    return cell;
    
}


- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
    
}




@end
