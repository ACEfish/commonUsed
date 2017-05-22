//
//  ITSheetBlockView.m
//  弹窗组件
//
//  Created by 栗豫塬 on 16/12/6.
//  Copyright © 2016年 fish. All rights reserved.
//

#import "ITSheetBlockView.h"
#import "Masonry.h"

#define kTableCellHeight 60
#define kTableFootViewHeight kTableCellHeight+10


@interface ITSheetBlockView ()<UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UITableView *mainTableView;

@property (nonatomic, strong) NSMutableArray *btnDataArray;
@property (nonatomic, strong) NSMutableArray *blockArray;
@property (nonatomic, copy) NSString *cancelTitle;
@property (nonatomic, copy) SheetBtnBlock cancelBtnBlock;

@end

@implementation ITSheetBlockView

+ (instancetype)sheetWithCancelTitle:(NSString *)cancelTitle cancelBlock:(SheetBtnBlock)cancelBtnBlock {
    return [[ITSheetBlockView alloc] initWithCancelTitle:cancelTitle cancelBlock:cancelBtnBlock];
}

- (instancetype)initWithCancelTitle:(NSString *)cancelTitle cancelBlock:(SheetBtnBlock)cancelBtnBlock {
    if (self = [super init]) {
        if (!cancelTitle) {
            self.cancelTitle = @"取消";
        } else {
            self.cancelTitle = cancelTitle;
        }
        self.cancelBtnBlock = cancelBtnBlock;
    }
    return self;
}

#pragma mark - 初始化视图 -

- (void)configView {
    CGFloat tableViewH = self.btnDataArray.count * kTableCellHeight + kTableFootViewHeight;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    UITableView *tableView= [[UITableView alloc]initWithFrame:CGRectMake(0, screenH, screenW, tableViewH) style:UITableViewStylePlain];
    tableView.delegate = self;
    tableView.dataSource = self;
    tableView.rowHeight = kTableCellHeight;
    tableView.bounces = NO;
    UIView *footView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, screenW, kTableFootViewHeight)];
    footView.backgroundColor = [UIColor lightGrayColor];
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(0, kTableFootViewHeight - kTableCellHeight, screenW, kTableCellHeight);
    cancelBtn.backgroundColor = [UIColor whiteColor];
    [cancelBtn setTitleColor:[UIColor orangeColor] forState:UIControlStateNormal];
    [cancelBtn setTitle:self.cancelTitle forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelBtnClick) forControlEvents:UIControlEventTouchUpInside];
    [footView addSubview:cancelBtn];
    tableView.tableFooterView = footView;
    [tableView setSeparatorInset:UIEdgeInsetsZero];
    [tableView setLayoutMargins:UIEdgeInsetsZero];
    [self addSubview:tableView];
    self.mainTableView = tableView;
}






#pragma mark - tableViewDelegate -


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.btnDataArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *identifier = @"identifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identifier];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    UILabel *titleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, screenW, kTableCellHeight)];
    titleLabel.textAlignment = NSTextAlignmentCenter;
    [cell addSubview:titleLabel];
    titleLabel.text = self.btnDataArray[indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    SheetBtnBlock btnBlock = self.blockArray[indexPath.row];
    if (btnBlock) {
        [self hideWithCompletion:btnBlock];
    } else {
        [self hideWithCompletion:nil];
    }
    
}


#pragma mark - event-

- (void)addBtnTitle:(NSString *)btnTitle btnBlock:(SheetBtnBlock)btnBlock {
    [self.btnDataArray addObject:(btnTitle ? btnTitle : @"未命名")];
    if (btnBlock) {
        [self.blockArray addObject:btnBlock];
    } else {
        [self.blockArray addObject:[NSNull null]];
    }

}


- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesBegan:touches withEvent:event];
    [self hideWithCompletion:nil];
}

#pragma mark - show && hide -

- (void)cancelBtnClick {
    [self hideWithCompletion:self.cancelBtnBlock];
}


- (void)show {
    CGFloat screenW = [UIScreen mainScreen].bounds.size.width;
    CGFloat screenH = [UIScreen mainScreen].bounds.size.height;
    self.frame = CGRectMake(0, 0, screenW, screenH);
    [self configView];
    self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
    [[UIApplication sharedApplication].keyWindow addSubview:self];
    CGFloat tableViewH = self.btnDataArray.count * kTableCellHeight + kTableFootViewHeight;
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
        self.mainTableView.transform = CGAffineTransformMakeTranslation(0, -tableViewH);
    } completion:nil];
    
}

- (void)hideWithCompletion:(SheetBtnBlock)btnBlock {
    [UIView animateWithDuration:0.5 animations:^{
        self.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0];
        self.mainTableView.transform = CGAffineTransformIdentity;
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
        if (btnBlock) {
            btnBlock();
        }
    }];
}

#pragma mark - setter&getter -

- (NSMutableArray *)btnDataArray {
    if (!_btnDataArray) {
        _btnDataArray = [NSMutableArray array];
    }
    return _btnDataArray;
}


- (NSMutableArray *)blockArray {
    if (!_blockArray) {
        _blockArray = [NSMutableArray array];
    }
    return _blockArray;
}


@end
