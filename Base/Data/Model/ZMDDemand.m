//
//  ZMDDemand.m
//  Base
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ZMDDemand.h"

@implementation ZMDDemand

+(NSDictionary*)modelCustomPropertyMapper {
    return @{@"companyName":@"company_name",@"jobName":@"job_name",@"jobId":@"job_id",@"detailUrl":@"detail_url",@"canShare":@"can_share"};
}

@end
