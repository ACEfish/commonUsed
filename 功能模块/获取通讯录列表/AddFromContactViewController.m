//
//  AddFromContactViewController.m
//  conductor
//
//  Created by 陈煌 on 16/6/2.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import "AddFromContactViewController.h"
#import "GetAllContacts.h"
#import "SearchControllerOfContacts.h"
#import "PhoneContactUserGroupModel.h"
#import "TLContact.h"
#import "ContactsOfCell.h"
#import "DetailOfContactsViewController.h"

@interface AddFromContactViewController ()

@property (nonatomic, strong) SearchControllerOfContacts *searchController;
@property (nonatomic, strong) SearchResultViewController *searchVC;
@property (nonatomic, strong) MsgSearchConductorRsp      *pbObj;
@property (nonatomic, strong) NSMutableArray             *registeredPhoneAndIdArray;

@end

@implementation AddFromContactViewController

- (void)viewWillAppear:(BOOL)animated {
    
    [ITNotificationCenter addObserver:self selector:@selector(receiveRegisteredUser:) name:[ClientMsgType_EnumDescriptor() enumNameForValue:ClientMsgType_SearchConductorRsp] object:nil];
}

- (void)viewWillDisappear:(BOOL)animated {
    
    [ITNotificationCenter removeObserver:self];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    [self.navigationItem setTitle:@"通讯录朋友"];
    [self.view setBackgroundColor:[UIColor whiteColor]];
    [self.tableView setSectionIndexBackgroundColor:[UIColor clearColor]];
    [self.tableView setTableHeaderView:self.searchController.searchBar];
    [MBProgressHUD showHUDAddedTo:self.view animated:YES];
    
    
    ITWeakSelf(weakSelf);
    //获取手机通讯录
    [GetAllContacts tryToGetAllContactsSuccess:^(NSArray *data, NSArray *formatData) {

        weakSelf.contactsData = data;
        
        //获取通讯录中的所有电话
        long int count = [data count];
        for (int i = 0 ; i < count; i++) {
            TLContact *contact = [data objectAtIndex:i];
            if (contact.tel) {
                [weakSelf.telArray addObject:contact.tel];
            }
        }

        //发送通讯录号码
        [weakSelf searchConductor];
        
    } failed:^{ }];
    
   }



- (void)searchConductor {

    MsgSearchConductorReq *searchConductorReq = [[MsgSearchConductorReq alloc] init];
    [searchConductorReq setDesPhoneArray:self.telArray];
    searchConductorReq.searchType = YQSearchType_PhoneSearch;
    searchConductorReq.userId = [UserDataManager sharedInstance].currentUser.userId.intValue;
    [[MQTTManager sharedInstance] sendMessageWithMsgType:ClientMsgType_SearchConductorReq Data:searchConductorReq.data Topic:PublishLoginServerTopic];
}

- (void)receiveRegisteredUser:(NSNotification *)notice {
    
    self.pbObj = notice.object;
    
    
    ITWeakSelf(weakSelf);
    [self tryToGetContactsSuccess:^(NSArray *data, NSArray *formatData, NSArray *headers) {
        weakSelf.data = formatData;
        weakSelf.headers = headers;
        [weakSelf.tableView reloadData];
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        
        if (formatData.count == 0) {

            [ITAlertBlockView showWithTitle:ITLocalStr(暂无已注册指挥家的联系人) subTitle:nil cancleBtnTitle:ITLocalStr(确定) cancleBtnBlock:^{
                [self.navigationController popViewControllerAnimated:YES];
            }];
        }
    }];
    
}


- (void)tryToGetContactsSuccess:(void (^)(NSArray *data, NSArray *formatData, NSArray *headers))success{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSMutableArray *data = [[NSMutableArray alloc] init];

        //获取通讯录中已注册用户
        for (int i = 0 ; i < self.pbObj.contactInfoArray_Count; i++) {
            YQContactInfo *aContact = self.pbObj.contactInfoArray[i];
            NSString *PhoneAndId = [NSString stringWithFormat:@"%@,%d",aContact.cellPhone,(int)aContact.userId];
            [self.registeredPhoneAndIdArray addObject:PhoneAndId];
        }

        //将已注册用户添加到模型数组
        for (int index = 0 ; index < self.registeredPhoneAndIdArray.count; index++) {
            NSString *PhoneAndIDString = self.registeredPhoneAndIdArray[index];
            NSArray  *array      = [PhoneAndIDString componentsSeparatedByString:@","];
            NSString *userPhone  = array[0];
            NSString *userID     = array[1];

            for (int i = 0 ; i < [self.contactsData count]; i++) {
                TLContact *contact = [self.contactsData objectAtIndex:i];
                if ([contact.tel isEqualToString:userPhone]) {
                    contact.contactId = userID;
                    [data addObject:contact];
                }
            }
        }
        //排序
        NSArray *serializeArray = [data sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
            int i;
            NSString *strA = ((TLContact *)obj1).pinyin;
            NSString *strB = ((TLContact *)obj2).pinyin;
            for (i = 0; i < strA.length && i < strB.length; i ++) {
                char a = toupper([strA characterAtIndex:i]);
                char b = toupper([strB characterAtIndex:i]);
                if (a > b) {
                    return (NSComparisonResult)NSOrderedDescending;
                }
                else if (a < b) {
                    return (NSComparisonResult)NSOrderedAscending;
                }
            }
            if (strA.length > strB.length) {
                return (NSComparisonResult)NSOrderedDescending;
            }
            else if (strA.length < strB.length){
                return (NSComparisonResult)NSOrderedAscending;
            }
            return (NSComparisonResult)NSOrderedSame;
        }];
        
        //分组
        data = [[NSMutableArray alloc] init];
        NSMutableArray *headers = [[NSMutableArray alloc] initWithObjects:UITableViewIndexSearch, nil];
        char lastC = '1';
        PhoneContactUserGroupModel *curGroup;
        PhoneContactUserGroupModel *othGroup = [[PhoneContactUserGroupModel alloc] init];
        [othGroup setGroupName:@"#"];
        for (TLContact *contact in serializeArray) {
            // 获取拼音失败
            if (contact.pinyin == nil || contact.pinyin.length == 0) {
                [othGroup addObject:contact];
                continue;
            }
            
            char c = toupper([contact.pinyin characterAtIndex:0]);
            if (!isalpha(c)) {      // #组
                [othGroup addObject:contact];
            }
            else if (c != lastC){
                if (curGroup && curGroup.count > 0) {
                    [data addObject:curGroup];
                    [headers addObject:curGroup.groupName];
                }
                lastC = c;
                curGroup = [[PhoneContactUserGroupModel alloc] init];
                [curGroup setGroupName:[NSString stringWithFormat:@"%c", c]];
                [curGroup addObject:contact];
            }
            else {
                [curGroup addObject:contact];
            }
        }
        if (curGroup && curGroup.count > 0) {
            [data addObject:curGroup];
            [headers addObject:curGroup.groupName];
        }
        if (othGroup.count > 0) {
            [data addObject:othGroup];
            [headers addObject:othGroup.groupName];
        }
        
        //数据返回
        dispatch_async(dispatch_get_main_queue(), ^{
            success(serializeArray, data, headers);
        });
        
        
    });
}


#pragma mark - Getter -
- (NSMutableArray *)registeredPhoneAndIdArray {
    
    if (_registeredPhoneAndIdArray == nil) {
        _registeredPhoneAndIdArray = [[NSMutableArray alloc]init];
    }
    return _registeredPhoneAndIdArray;
}

- (SearchControllerOfContacts *)searchController {
    
    if (_searchController == nil) {
        _searchController = [[SearchControllerOfContacts alloc] initWithSearchResultsController:self.searchVC];
        //[_searchController setSearchResultsUpdater:self.searchVC];
        [_searchController.searchBar setPlaceholder:@"账号、昵称、指挥家ID"];
    }
    return _searchController;
}

- (NSMutableArray *)telArray {
    if (_telArray == nil) {
        _telArray = [[NSMutableArray alloc]init];
    }
    return _telArray;
}




#pragma mark -  UITableViewDataSource -
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.data.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    PhoneContactUserGroupModel *group = [self.data objectAtIndex:section];
    return group.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    TLContact *contact = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    
    static NSString *ID = @"ContactOfAdd";
    ContactsOfCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        cell = [[ContactsOfCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:ID];
    }
    cell.textLabel.text = contact.name;
    cell.imageView.image = [UIImage imageNamed:@"contact_ default"];
    return cell;
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    
    PhoneContactUserGroupModel *group = [self.data objectAtIndex:section];
    return group.groupName;
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.headers;
}

#pragma mark -  UITableViewDelegate -
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    [tableView deselectRowAtIndexPath:indexPath animated:NO];
    TLContact *contact = [self.data[indexPath.section] objectAtIndex:indexPath.row];
    DetailOfContactsViewController *detailVC = [[DetailOfContactsViewController alloc]init];
    detailVC.contact = contact;
    [self.navigationController pushViewController:detailVC animated:YES];
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 55.0f;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
    return 22.0f;
}



@end
