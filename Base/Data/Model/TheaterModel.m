//
//  TheaterModel.m
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterModel.h"

@implementation TheaterModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"playName":@"play_name",
             @"playId":@"play_id",
             @"classId":@"class_id",
             @"createTime":@"create_time",
             @"updateTime":@"update_time",
             @"desc":@"description",
             };
}

@end
