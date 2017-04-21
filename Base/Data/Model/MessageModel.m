//
//  MessageModel.m
//  Base
//
//  Created by admin on 2017/4/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MessageModel.h"

@implementation MessageModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"noticeId":@"id",
             @"noticeCode":@"notice_code",
             @"orderId":@"order_id",
             @"orderType":@"order_type",
             @"userId":@"user_id",
             @"createTime":@"create_time",
             @"updateTime":@"update_time",
             };
}

@end
