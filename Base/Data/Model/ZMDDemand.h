//
//  ZMDDemand.h
//  Base
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseModel.h"

@interface ZMDDemand : BaseModel

@property (nonatomic, copy) NSString *companyName;
@property (nonatomic, copy) NSString *jobName;
@property (nonatomic, copy) NSString *jobId;
@property (nonatomic, copy) NSString *summary;
@property (nonatomic, copy) NSString *edu;
@property (nonatomic, copy) NSString *exp;
@property (nonatomic, copy) NSString *detailUrl;
@property (nonatomic, copy) NSString *canShare;

@end
