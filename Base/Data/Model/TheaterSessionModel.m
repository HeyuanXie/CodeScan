//
//  TheaterSessionModel.m
//  Base
//
//  Created by admin on 2017/4/5.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterSessionModel.h"

@implementation TheaterSessionModel

+ (nullable NSDictionary<NSString *, id> *)modelContainerPropertyGenericClass {
    
    return @{
             @"children":[TheaterModel class],
             };
}

+ (nullable NSDictionary<NSString *, id> *)modelCustomPropertyMapper {
    
    return @{
             @"theaterName":@"theatre_name",
             @"theaterId":@"theatre_id",
             };
}

@end
