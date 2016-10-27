//
//  PromptCell.h
//  XG
//
//  Created by deejan on 15/9/7.
//  Copyright (c) 2015年 memobird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *mainTitle;
@property (strong, nonatomic) IBOutlet UILabel *tipTitle;

@property (strong, nonatomic) IBOutlet UIImageView *rightImg;


- (void)cellSelected:(BOOL)bSelected;

@end
