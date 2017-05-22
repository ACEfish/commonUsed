//
//  AddFromContactViewController.h
//  conductor
//
//  Created by 陈煌 on 16/6/2.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SearchResultViewController.h"

@interface AddFromContactViewController : UITableViewController

/// 通讯录好友（初始数据）
@property (nonatomic, strong) NSArray *contactsData;

/// 通讯录好友（格式化的列表数据）
@property (nonatomic, strong) NSArray *data;

/// 通讯录好友索引
@property (nonatomic, strong) NSArray *headers;

///通讯录中所有电话号码
@property (nonatomic, strong) NSMutableArray *telArray;


@end
