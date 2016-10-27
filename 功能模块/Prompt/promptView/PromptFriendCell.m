//
//  PromptFriendCell.m
//  XG
//
//  Created by intretech on 15/10/24.
//  Copyright © 2015年 memobird. All rights reserved.
//

#import "PromptFriendCell.h"

@implementation PromptFriendCell

- (void)cellSelected:(BOOL)bSelected
{
    NSString *imgStr = @"check_box_off.png";
    if (bSelected) {
        imgStr = @"check_box_on.png";
    }
    self.selectImg.image = [UIImage imageNamed:imgStr];
}

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self.contentView addSubview:self.headImg];
        [self.contentView addSubview:self.nameLab];
        [self.contentView addSubview:self.selectImg];
    }
    return self;
}

- (UIImageView *)headImg{
    if (_headImg == nil) {
        _headImg = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, self.frame.size.height , self.frame.size.height )];
        _headImg.layer.cornerRadius = (self.frame.size.height)/2;
        _headImg.layer.masksToBounds = YES;
    }
    return _headImg;
}

- (UILabel *)nameLab
{
    if (_nameLab == nil) {
        _nameLab = [[UILabel alloc]initWithFrame:CGRectMake(self.headImg.frame.origin.x+self.headImg.frame.size.width+10, 10, self.frame.size.width-(self.headImg.frame.origin.x+self.headImg.frame.size.width+10) - 100, self.frame.size.height)];
    }
    return _nameLab;
}

-(UIImageView *)selectImg
{
    if (_selectImg == nil) {
        _selectImg = [[UIImageView alloc]initWithFrame:CGRectMake(245, 15, 30, 30)];
    }
    return _selectImg;
}

@end
