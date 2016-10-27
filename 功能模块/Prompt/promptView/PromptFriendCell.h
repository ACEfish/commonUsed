//
//  PromptFriendCell.h
//  XG
//
//  Created by intretech on 15/10/24.
//  Copyright © 2015年 memobird. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PromptFriendCell : UITableViewCell

@property (strong, nonatomic) UIImageView *headImg;
@property (strong, nonatomic) UILabel *nameLab;
@property (strong, nonatomic) UIImageView *selectImg;

- (void)cellSelected:(BOOL)bSelected;

@end
