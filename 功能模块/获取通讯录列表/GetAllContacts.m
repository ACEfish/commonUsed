//
//  GetAllContacts.m
//  conductor
//
//  Created by 陈煌 on 16/6/2.
//  Copyright © 2016年 intretech. All rights reserved.
//

#import "GetAllContacts.h"
#import "TLContact.h"
#import <AddressBookUI/AddressBookUI.h>

@implementation GetAllContacts

+ (void)tryToGetAllContactsSuccess:(void (^)(NSArray *data, NSArray *formatData))success
                            failed:(void (^)())failed {
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //获取通讯录信息
        ABAddressBookRef addressBooks = nil;
        if ([[UIDevice currentDevice].systemVersion floatValue] >= 6.0) {
            addressBooks =  ABAddressBookCreateWithOptions(NULL, NULL);
            dispatch_semaphore_t sema = dispatch_semaphore_create(0);
            ABAddressBookRequestAccessWithCompletion(addressBooks, ^(bool granted, CFErrorRef error){
                dispatch_semaphore_signal(sema);
            });
            dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
        }
        else {
            addressBooks = ABAddressBookCreate();
        }
        
        CFArrayRef allPeople = ABAddressBookCopyArrayOfAllPeople(addressBooks);
        CFIndex nPeople = ABAddressBookGetPersonCount(addressBooks);
        
        
        //格式转换
        NSMutableArray *data = [[NSMutableArray alloc] init];
        for (NSInteger i = 0; i < nPeople; i++) {
            TLContact  *contact = [[TLContact  alloc] init];
            ABRecordRef person = CFArrayGetValueAtIndex(allPeople, i);
            CFTypeRef abName = ABRecordCopyValue(person, kABPersonFirstNameProperty);
            CFTypeRef abLastName = ABRecordCopyValue(person, kABPersonLastNameProperty);
            CFStringRef abFullName = ABRecordCopyCompositeName(person);
            NSString *nameString = (__bridge NSString *)abName;
            NSString *lastNameString = (__bridge NSString *)abLastName;
            
            if ((__bridge id)abFullName != nil) {
                nameString = (__bridge NSString *)abFullName;
            }
            else {
                if ((__bridge id)abLastName != nil) {
                    nameString = [NSString stringWithFormat:@"%@ %@", nameString, lastNameString];
                }
            }
            contact.name = nameString;
            ABPropertyID multiProperties[] = {
                kABPersonPhoneProperty,
                kABPersonEmailProperty
            };
            NSInteger multiPropertiesTotal = sizeof(multiProperties) / sizeof(ABPropertyID);
            for (NSInteger j = 0; j < multiPropertiesTotal; j++) {
                ABPropertyID property = multiProperties[j];
                ABMultiValueRef valuesRef = ABRecordCopyValue(person, property);
                NSInteger valuesCount = 0;
                if (valuesRef != nil) valuesCount = ABMultiValueGetCount(valuesRef);
                if (valuesCount == 0) {
                    CFRelease(valuesRef);
                    continue;
                }
                for (NSInteger k = 0; k < valuesCount; k++) {
                    CFTypeRef value = ABMultiValueCopyValueAtIndex(valuesRef, k);
                    switch (j) {
                        case 0: {// Phone number
                            contact.tel = (__bridge NSString*)value;
                            contact.tel = [contact.tel stringByReplacingOccurrencesOfString:@"-" withString:@""];
                            contact.tel = [contact.tel stringByReplacingOccurrencesOfString:@"+86" withString:@""];
                            contact.tel = [contact.tel stringByReplacingOccurrencesOfString:@" " withString:@""];
                            break;
                        }
                        case 1: {

                            break;
                        }
                    }
                    CFRelease(value);
                }
                CFRelease(valuesRef);
            }
            [data addObject:contact];
            
            if (abName) CFRelease(abName);
            if (abLastName) CFRelease(abLastName);
            if (abFullName) CFRelease(abFullName);
        }

        
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
        

        
        //数据返回
        dispatch_async(dispatch_get_main_queue(), ^{
            success(serializeArray, data);
        });
        

    });
}

@end
