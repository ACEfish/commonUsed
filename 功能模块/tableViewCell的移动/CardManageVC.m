//
//  CardManageVC.m
//  SmartTouch
//
//  Created by chenjoy on 15-1-29.
//  Copyright (c) 2015年 joy. All rights reserved.
//

#import "CardManageVC.h"
#import "CardManageCell.h"
#import "SliderViewController.h"
#import "MainAppVC.h"
#import "StewardVC.h"
#import "BaseNavC.h"
#import "DeviceManager.h"
#import "JOYPrompt.h"

@interface CardManageVC ()

@property (strong, nonatomic) NSMutableArray *dataArray;
@property (strong, nonatomic) NSMutableArray *ignoreDataArray;


@end

@implementation CardManageVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.showsVerticalScrollIndicator = NO;
    self.title = @"卡片管理";
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed:@"icon_save_unchenked"] imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStyleBordered target:self action:@selector(rightBarBtClick)];
    self.dataArray = [NSMutableArray arrayWithArray:[CardManager shared].cardArray];
    self.ignoreDataArray = [NSMutableArray arrayWithArray:[CardManager shared].ignoreCardArray];
    
    [self.tableView setEditing:YES];
}

- (void)rightBarBtClick
{
    NSLog(@"save bt click");
    if ([[DeviceManager shared].smartCores count] == 0) {
        [[Toast makeText:@"没有主机无法调整卡片顺序"] show];
        return;
    }
    [CardManager shared].cardArray = [NSMutableArray arrayWithArray:self.dataArray];
    [CardManager shared].ignoreCardArray = [NSMutableArray arrayWithArray:self.ignoreDataArray];

    [[CardManager shared] saveData];
    MainAppVC *mainVC = (MainAppVC *)[SliderViewController sharedSliderController].MainVC ;
    if (mainVC) {
        BaseNavC *baseNavc = (BaseNavC *)[mainVC getVCByIndex:0];
        if (baseNavc) {
            StewardVC *stewardVC = (StewardVC *)[baseNavc.viewControllers objectAtIndex:0];
            if (stewardVC) {
                [stewardVC reloadData];
            }
        }

    }
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark table view delegate 

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    
    return 30;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return CELL_HEIGHT;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 30)];
    view.backgroundColor = [UIColor whiteColor];
    UIView *line = [[UIView alloc] initWithFrame:CGRectMake(5, view.height/2, view.width-10, .5)];
    line.backgroundColor = BOTTOM_LINE_COLOR;
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(30, 5, 50, 20)];
    title.textAlignment = NSTextAlignmentCenter;
    title.backgroundColor = [UIColor whiteColor];
    title.textColor = MAIN_TITLE_COLOR;
    [view addSubview:line];
    [view addSubview:title];
    if (0==section) {
        title.text = @"显示";
    }else if (1==section) {
        title.text = @"隐藏";
    }
    return view;
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSInteger count = 0;
    if (0 == section) {
        count = [self.dataArray count];
    }
    else if (1 == section)
    {
        count = [self.ignoreDataArray count];
//        if(0 == count)
//        {
//            count = 1;
//        }
    }
    return count;
}



- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CardManageCell";
    CardManageCell *cell = (CardManageCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (nil == cell) {
        cell = [CardManageCell loadFromNib];
        [cell.bt addTarget:self action:@selector(cellBtClick:) forControlEvents:UIControlEventTouchUpInside];
        cell.bt.enabled = NO;
    }
    [cell reset];
    cell.bt.indexPath = indexPath;
    CardObj *cardObj = nil;
    if (0 == indexPath.section) {
        if (0 == [self.dataArray count]) {
            [cell hiddenCardCell];
        }
        else
        {
            cardObj = [self.dataArray objectAtIndex:indexPath.row];
        }
    }
    else if (1 == indexPath.section)
    {
        if (0 == [self.ignoreDataArray count]) {
            [cell hiddenCardCell];
        }
        else
        {
            cardObj = [self.ignoreDataArray objectAtIndex:indexPath.row];
        }
    }
    // Configure the cell...
    if(cardObj)
    {
        [cell setDataWithCardType:cardObj.cardType];
    }
    return cell;
}

#pragma mark --base sub vc的返回按钮回调
- (BOOL)confirmToPopVC
{
    JOYPrompt *promptView = [JOYPrompt prompt:@"退出将丢失已修改信息，是否确认退出？" confirm:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    } cancel:^{
        
    }];
    [promptView setConfirmText:@"确认"];
    [promptView setCancelText:@"取消"];
    promptView.title.text = @"卡片管理";
    
    return NO;
}

#pragma mark -
#pragma mark Table view data source


//编辑状态下，只要实现这个方法，就能实现拖动排序
-(void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)sourceIndexPath toIndexPath:(NSIndexPath *)destinationIndexPath{
    //这里通过修改数据源数据，将数组内容重新排序
    
    CardObj *cardObj = nil;
    
    if (sourceIndexPath.section == 0) {
        cardObj = [self.dataArray objectAtIndex:[sourceIndexPath row]];
        [self.dataArray removeObjectAtIndex:[sourceIndexPath row]];
    }
    else
    {
        cardObj = [self.ignoreDataArray objectAtIndex:[sourceIndexPath row]];
        [self.ignoreDataArray removeObjectAtIndex:[sourceIndexPath row]];
    }
    
    
    
    if (destinationIndexPath.section == 0) {
        [self.dataArray insertObject:cardObj atIndex:[destinationIndexPath row]];
    }
    else
    {
        if ([self.ignoreDataArray count] == 0) {
            [self.ignoreDataArray addObject:cardObj];
        }
        else
        {
            [self.ignoreDataArray insertObject:cardObj atIndex:[destinationIndexPath row]];
        }
    }
}

//移除系统自带的编辑图片
- (void) tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    for(UIView* view in cell.subviews){
        if([[[view class] description] isEqualToString:@"UITableViewCellReorderControl"]){
            UIView *movedReorderControl = [[UIView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetMaxX(view.frame), CGRectGetMaxY(view.frame))];
            [movedReorderControl addSubview:view];
            [cell addSubview:movedReorderControl];
            [view.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
        }
    }
    
}


- (UITableViewCellEditingStyle)tableView:(UITableView *)tableView editingStyleForRowAtIndexPath:(NSIndexPath *)indexPath{
    return UITableViewCellEditingStyleNone;
}



- (BOOL)canMoveIndexPath:(NSIndexPath *)indexPath
{
    if (0 == indexPath.section && [self.dataArray count] == 0) {
        return NO;
    }
    if (1 == indexPath.section && [self.ignoreDataArray count] == 0) {
        return NO;
    }
    return YES;
}

- (BOOL)cellCanMoveAtIndexPath:(NSIndexPath *)indexPath touchPoint:(CGPoint)point
{
    if ([[DeviceManager shared].smartCores count] == 0) {
        [[Toast makeText:@"没有主机无法调整卡片顺序"] show];
        return NO;
    }
    CardManageCell *cell = (CardManageCell *)[self.tableView cellForRowAtIndexPath:indexPath];
    CGRect rect = [cell convertRect:cell.contentView.frame toView:self.tableView];
    if (CGRectContainsPoint(rect, point)) {
        return YES;
    }
    
    return NO;
}


- (void)cellBtClick:(JOYCommonBt *)bt
{

}




@end
