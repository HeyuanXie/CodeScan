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
             @"faceUrl":@"header_img",
             @"nickName":@"nickname",
             @"sex":@"gender",
             @"birthday":@"birthday",
             @"phone":@"phone",
             @"areaId":@"city_id",
             @"areaName":@"city_name",
             };
}

@end
