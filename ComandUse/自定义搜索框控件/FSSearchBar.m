//
//  FSSearchBar.m
//  FSWeiBo
//
//  Created by qingyun on 16/1/26.
//  Copyright © 2016年 qingyun.com. All rights reserved.
//

#import "FSSearchBar.h"

@implementation FSSearchBar

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        self.font = [UIFont systemFontOfSize:15];
        self.placeholder = @"请输入搜索条件";
        self.background = [UIImage imageNamed:@"searchbar_textfield_background"];
        UIImageView *searchIcon = [[UIImageView alloc]init];
        searchIcon.image = [UIImage imageNamed:@"searchbar_textfield_search_icon"];
        searchIcon.width = 30;
        searchIcon.height = 30;
        searchIcon.contentMode = UIViewContentModeCenter;
        self.leftView = searchIcon;
        self.leftViewMode = UITextFieldViewModeAlways;
        
    }
    return self;
}



+ (instancetype)searchBar{
    //默认会调用initWithFrame
    return [[FSSearchBar alloc]init];
}

@end
