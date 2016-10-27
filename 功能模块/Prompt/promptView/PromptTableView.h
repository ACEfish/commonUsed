//
//  PromptTableView.h
//  XG
//
//  Created by deejan on 15/9/7.
//  Copyright (c) 2015年 memobird. All rights reserved.
//

#import <UIKit/UIKit.h>
@class PromptTableView;

typedef NS_ENUM(NSInteger, SelectionStatus) {
    SelectionStatusMultiple,
    SelectionStatusSingle
};

typedef enum : NSUInteger {
    deviceSelect,
    friendSelect,
} promptTableStyle;

typedef void(^PromptTableConfirmBlock) (NSInteger selectedIndex);
typedef void(^PromptTableMultipleConfirmBlock) (NSArray *deviceArr);
typedef void(^PromptTableCancelBlock) (void);


@interface PromptTableView : UIView

@property (copy, nonatomic) PromptTableConfirmBlock confirmBlock;
@property (copy, nonatomic) PromptTableMultipleConfirmBlock multipleConfirmBlock;
@property (copy, nonatomic) PromptTableCancelBlock cancelBlock;
@property (strong, nonatomic) NSArray *dataArr;
@property (copy, nonatomic) NSString *userName;
@property (assign, nonatomic) NSInteger style;

+ (PromptTableView *)promptTableView:(NSString *)title;

+ (PromptTableView *)promptTableView:(NSString *)title
                  AndSelectionStatus:(SelectionStatus)selectionStatus
                      AndSubsDevices:(NSArray *)subsDevices;

- (void)setBt:(NSString *)btTitle block:(PromptTableConfirmBlock)confirmBlock;

- (void)setBt:(NSString *)btTitle multipleBlock:(PromptTableMultipleConfirmBlock)multipleConfirmBlock;

- (void)show;

- (void)showBy:(UIViewController *)vc;

- (void)showIndicator;
@end
