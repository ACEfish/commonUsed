//
//  GetAllContacts.h
//  conductor
//
//  Created by 陈煌 on 16/6/2.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface GetAllContacts : NSObject

/** 获取通讯录列表 */

+ (void)tryToGetAllContactsSuccess:(void (^)(NSArray *data, NSArray *formatData))success failed:(void (^)())failed;

@end
