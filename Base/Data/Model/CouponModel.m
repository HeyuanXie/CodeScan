//
//  CouponModel.m
//  Base
//
//  Created by admin on 2017/4/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CouponModel.h"

@implementation CouponModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"couponName":@"coupon_name",
             @"couponSn":@"coupon_sn",
             @"usedAmount":@"used_amount",
             @"couponAmount":@"coupon_amount",
             @"expireTime":@"expire_time",
             @"orderType":@"order_type"
             };
}

@end
