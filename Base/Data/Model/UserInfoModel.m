//
//  UserInfoModel.m
//  Base
//
//  Created by admin on 2017/3/2.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UserInfoModel.h"

@implementation UserInfoModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"userID":@"user_id",
             @"account":@"account",
             @"faceUrl":@"face",
             @"nickName":@"nickname",
             @"sex":@"sex",
             @"birthday":@"birthday",
             @"areaID":@"area_id",
             @"phone":@"phone",
             @"areaName":@"area_name",
             };
}

@end
