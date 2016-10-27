//
//  PromptTableView.m
//  XG
//
//  Created by deejan on 15/9/7.
//  Copyright (c) 2015年 memobird. All rights reserved.
//

#import "PromptTableView.h"
#import "PromptCell.h"
#import "UserDataManager.h"
#import "PromptFriendCell.h"
#import "UIImageView+WebCache.h"


@interface PromptTableView ()<UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) IBOutlet UIView *bgView;
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UITableView *tableView;
@property (strong, nonatomic) IBOutlet UIButton *confirmBt;

@property (strong, nonatomic) NSMutableArray *selectedArr;
@property (strong, nonatomic) NSArray *subsDevices;
@property (assign, nonatomic) SelectionStatus selectionStatus;
@property (assign, nonatomic) NSInteger selectedIndex;



- (void)setup;

@end

@implementation PromptTableView

- (void)awakeFromNib{
    [super awakeFromNib];
    
    self.frame = CGRectMake(0, 0, SCREEN_WIDTH, SCREEN_HEIGHT);
    self.bgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
//    [self.bgView setCornerRadius:5];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.tableFooterView = [[UIView alloc] init];
//    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(cancelSelect)];
//    [self.bgView addGestureRecognizer:tapGesture];
    [self setup];
}

+ (PromptTableView *)promptTableView:(NSString *)title
{
    PromptTableView *view = [PromptTableView loadFromNIB];
    view.titleLabel.text = title;
    view.selectionStatus = SelectionStatusSingle;
    return view;
}

+ (PromptTableView *)promptTableView:(NSString *)title
                  AndSelectionStatus:(SelectionStatus)selectionStatus
                      AndSubsDevices:(NSArray *)subsDevices{
    PromptTableView *view = [PromptTableView loadFromNIB];
    view.titleLabel.text = title;
    view.selectionStatus = selectionStatus;
    view.subsDevices = subsDevices;
    return view;
}

- (void)setBt:(NSString *)btTitle block:(PromptTableConfirmBlock)confirmBlock
{
    [self.confirmBt setTitle:btTitle forState:UIControlStateNormal];
    self.confirmBlock = confirmBlock;
}

- (void)setBt:(NSString *)btTitle multipleBlock:(PromptTableMultipleConfirmBlock)multipleConfirmBlock
{
    [self.confirmBt setTitle:btTitle forState:UIControlStateNormal];
    self.multipleConfirmBlock = multipleConfirmBlock;
}

- (void)show
{
    UIViewController *vc = [UIApplication sharedApplication].keyWindow.rootViewController;
    self.backgroundColor = RGBA(0, 0, 0, .4);
    [vc.view addSubview:self];
}

- (void)showBy:(UIViewController *)vc
{
    self.backgroundColor = RGBA(0, 0, 0, .4);
    [vc.view addSubview:self];
}

- (void)setup
{
    self.selectedIndex = 0;
    self.titleLabel.textColor = kProjectColorBlue;
    self.confirmBt.backgroundColor = kProjectColorBlue;
    [self.confirmBt setCornerRadius:5];
}

- (void)setDataArr:(NSArray *)dataArr
{
    _dataArr = [dataArr copy];
    CGFloat cellHeight = 61;
    CGFloat tableHeight = 2*cellHeight;
    if ([_dataArr count]>2) {
        tableHeight = 3*cellHeight;
    }
    self.tableView.height = tableHeight;
    self.bgView.height = 117+tableHeight;
    self.confirmBt.top = self.tableView.bottom+17;
    for (int i = 0; i < _dataArr.count; i++) {
        BOOL isSelected = NO;
        NSNumber *selection = [NSNumber numberWithBool:isSelected];
        [self.selectedArr addObject:selection];
    }
    
    self.bgView.center = CGPointMake(SCREEN_WIDTH/2, SCREEN_HEIGHT/2);
}

- (void)showIndicator{
    [self.tableView flashScrollIndicators];
}

#pragma mark - Table view data source

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return [self.dataArr count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    UIButton *cancelBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    cancelBtn.frame = CGRectMake(self.bgView.frame.size.width-10-40 , 10, 40, 40);
    cancelBtn.imageEdgeInsets = UIEdgeInsetsMake(10, 10, 10, 10);
    [cancelBtn setImage:[UIImage imageNamed:@"close.png"] forState:UIControlStateNormal];
    [cancelBtn addTarget:self action:@selector(cancelSelect) forControlEvents:UIControlEventTouchUpInside];
    [self.bgView addSubview:cancelBtn];
    if (self.style == friendSelect) {
        static NSString *CellIdentifier = @"FriendCell";
        PromptFriendCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (nil == cell) {
            cell = [[PromptFriendCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
//            [cell setSelectedBackgroundViewColor:[UIColor yellowColor]];
        }
        [cell cellSelected:self.selectedIndex==indexPath.row];
        
        FriendInfo *friendinfo = [self.dataArr objectAtIndex:indexPath.row];
        cell.nameLab.text = friendinfo.userName;
        [cell.headImg sd_setImageWithURL:[NSURL URLWithString:friendinfo.pic]
                        placeholderImage:[UIImage imageNamed:kCommonIconDefaultHeadStr]];
        
        return cell;
    }else{
        static NSString *CellIdentifier = @"PromptCell";
        PromptCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        if (nil == cell) {
            cell = [PromptCell loadFromNib];
//            [cell setSelectedBackgroundViewColor:[UIColor yellowColor]];
        }
        if (self.selectionStatus == SelectionStatusSingle) {
            [self.bgView addSubview:cancelBtn];
            
            [cell cellSelected:self.selectedIndex==indexPath.row];
            Device *device = [self.dataArr objectAtIndex:indexPath.row];
            cell.mainTitle.text = device.name;
            cell.tipTitle.text = self.userName;
            if ([cell.tipTitle.text isEqualToString:@""]||cell.tipTitle.text == nil) {
                [cell.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    
                }];
            }
        }else if (self.selectionStatus == SelectionStatusMultiple){
            BOOL isSelected = NO;
            Device *device = [self.dataArr objectAtIndex:indexPath.row];
            cell.mainTitle.text = device.name;
            cell.tipTitle.text = self.userName;
            NSString *deviceGuid = device.guid;
            for (NSString *guid in self.subsDevices) {
                isSelected = [self matchDevice:guid andOtherDevice:deviceGuid];
                if (isSelected) {
                    break;
                }
            }
            if ([cell.tipTitle.text isEqualToString:@""]||cell.tipTitle.text == nil) {
                [cell.mainTitle mas_makeConstraints:^(MASConstraintMaker *make) {
                    make.centerY.equalTo(cell.mas_centerY);
                    
                }];
            }
            [self.selectedArr replaceObjectAtIndex:indexPath.row withObject:[NSNumber numberWithBool:isSelected]];
            [cell cellSelected:isSelected];
            
        }
        return cell;
    }
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    switch (self.selectionStatus) {
        case SelectionStatusSingle:
            if (self.selectedIndex != indexPath.row) {
                self.selectedIndex = indexPath.row;
                [self.tableView reloadData];
            }
            break;
            
        case SelectionStatusMultiple:{
            BOOL isSelected = [self.selectedArr[indexPath.row]boolValue];
            isSelected = !isSelected;
            NSNumber *temp = [NSNumber numberWithBool:isSelected];
            [self.selectedArr replaceObjectAtIndex:indexPath.row withObject:temp];
//            [self.tableView reloadData];
            PromptCell *cell = [tableView cellForRowAtIndexPath:indexPath];
            [cell cellSelected:isSelected];
        }
            break;
            
        default:
            break;
    }
    
}

- (BOOL)matchDevice:(NSString *)guid andOtherDevice:(NSString *)otherGuid{
    
    
    return [guid isEqualToString:otherGuid];
}

- (IBAction)confirmBtClick:(id)sender {
    switch (self.selectionStatus) {
        case SelectionStatusSingle:
            if (self.confirmBlock) {
                _confirmBlock(self.selectedIndex);
            }
            break;
            
        case SelectionStatusMultiple:
            if (self.multipleConfirmBlock) {
                NSMutableArray *deviceArr = [NSMutableArray array];
                for (int i = 0; i < self.dataArr.count; i++) {
                    if ([self.selectedArr[i]boolValue]) {
                        [deviceArr addObject:self.dataArr[i]];
                    }
                }
                _multipleConfirmBlock(deviceArr);
            }
            break;
            
        default:
            break;
    }
    
    [self removeFromSuperview];
}

- (NSMutableArray *)selectedArr{
    if (!_selectedArr) {
        _selectedArr = [NSMutableArray array];
    }
    return _selectedArr;
}

- (void)cancelSelect{
    if (self.cancelBlock) {
        self.cancelBlock();
    }
    [self removeFromSuperview];
}

@end
