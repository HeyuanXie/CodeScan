//
//  CouponModel.h
//  Base
//
//  Created by admin on 2017/4/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseModel.h"

@interface CouponModel : BaseModel

@property (nonatomic, copy) NSString *couponAmount;
@property (nonatomic, copy) NSString *usedAmount;
@property (nonatomic, copy) NSString *couponSn;
@property (nonatomic, copy) NSString *expireTime;
@property (nonatomic, strong) NSNumber *orderType;
@property (nonatomic, copy) NSString *couponName;

@end
