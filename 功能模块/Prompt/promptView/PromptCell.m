//
//  PromptCell.m
//  XG
//
//  Created by deejan on 15/9/7.
//  Copyright (c) 2015年 memobird. All rights reserved.
//

#import "PromptCell.h"

@implementation PromptCell

- (void)awakeFromNib {
    self.rightImg.frame = CGRectMake(245, 15, 30, 30);
}

- (void)cellSelected:(BOOL)bSelected
{
    NSString *imgStr = @"check_box_off.png";
    if (bSelected) {
        imgStr = @"check_box_on.png";
    }
    self.rightImg.image = [UIImage imageNamed:imgStr];
}

@end
