
//
//  DeriveModel.m
//  Base
//
//  Created by admin on 2017/3/30.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "DeriveModel.h"

@implementation DeriveModel

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper{
    return @{
             @"shopPrice":@"shop_price",
             @"goodId":@"goods_id",
             @"img":@"thumb_img",
             @"goodName":@"goods_name",
             };
}
@end
