//
//  PromptView.h
//  XG
//
//  Created by chenjoy on 15/8/29.
//  Copyright (c) 2015年 memobird. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PromptConfirmBlock) (void);
typedef void (^PromptCancelBlock) (void);
typedef void (^PromptCloseBlock) (void);

@interface PromptView : UIView

@property (nonatomic, copy) PromptConfirmBlock confirmBlock;
@property (nonatomic, copy) PromptCancelBlock cancelBlock;
@property (nonatomic, copy) PromptCloseBlock closeBlock;

+ (PromptView *)promptView:(NSString *)title
                confirmStr:(NSString *)confirmStr
                   confirm:(PromptConfirmBlock)confirmBlock;

+ (PromptView *)promptView:(NSString *)title
                confirmStr:(NSString *)confirmStr
                   confirm:(PromptConfirmBlock)confirmBlock
                 cancelStr:(NSString *)cancelStr
                    cancel:(PromptCancelBlock)cancelBlock;
- (void)hideCloseBt;
- (void)show;

@end
