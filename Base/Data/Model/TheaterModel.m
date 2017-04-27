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
             @"subTitle":@"sub_title",
             @"playId":@"play_id",
             @"classId":@"class_id",
             @"createTime":@"create_time",
             @"updateTime":@"update_time",
             @"desc":@"description",
             @"isFav":@"is_fav",
             @"timeId":@"time_id",
             @"playTime":@"play_time",
             @"playDate":@"play_date",
             @"hallId":@"hall_id",
             @"theaterId":@"theatre_id",
             @"theaterName":@"theatre_name",
             @"payableAmount":@"payable_amount",
             @"sourceUrl":@"source_url"
             };
}

@end
