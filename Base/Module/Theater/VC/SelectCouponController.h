//
//  SelectCouponController.h
//  Base
//
//  Created by admin on 2017/3/27.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseTableViewController.h"
#import "SelectCouponCell.h"

typedef enum : NSUInteger {
    TypeCoupon,
    TypeYearCard,
} ContentType;

@interface SelectCouponController : BaseTableViewController

@property(nonatomic,assign)ContentType contentType;

@property(nonatomic,strong)NSMutableArray* dataArray;   //优惠券或年卡
@property(nonatomic,assign)NSInteger couponIndex;   //记录选择的哪张优惠券
@property(nonatomic,assign)NSInteger cardIndex;   //记录选择的哪张年卡
@property(nonatomic,copy)void (^selectFinish)(NSInteger index);

@end
