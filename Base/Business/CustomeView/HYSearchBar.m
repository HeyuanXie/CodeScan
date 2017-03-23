//
//  HYSearchBar.m
//  Base
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HYSearchBar.h"

@implementation HYSearchBar

+(instancetype)searchBarWithFrame:(CGRect)frame placeholder:(NSString *)placeholder {
    UITextField* textField = [[self alloc] initWithFrame:frame];
    textField.frame = frame;
    textField.backgroundColor = [UIColor whiteColor];
    textField.tintColor = [UIColor hyGrayTextColor];
    textField.font = [UIFont systemFontOfSize:15];
    
    // 通过init初始化的控件大多都没有尺寸
    UIView* leftView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 35, 30)];
    UIImageView *searchIcon = [[UIImageView alloc] initWithFrame:CGRectMake(10, 5, 20, 20)];
    searchIcon.image = [UIImage imageNamed:@"home_search"];
    searchIcon.contentMode = UIViewContentModeScaleAspectFit;
    [leftView addSubview:searchIcon];
    
    textField.leftView = leftView;
    textField.leftViewMode = UITextFieldViewModeAlways;
    if (placeholder != nil) {
        textField.placeholder = placeholder;
    }
    [HYTool configViewLayer:textField];
    return (HYSearchBar*)textField;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
    }
    return self;
}
@end
