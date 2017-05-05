//
//  TheaterCommitOrderController.h
//  Base
//
//  Created by admin on 2017/3/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseTableViewController.h"

@interface TheaterCommitOrderController : BaseTableViewController

@property (strong, nonatomic) NSArray* selectArray; //选择的座位的array
@property (strong, nonatomic) NSArray* coupons;
@property (strong, nonatomic) NSArray* yearCards;
@property (assign, nonatomic) NSInteger timeId; //剧场time_id
@property (assign, nonatomic) int timeLeft;   //订单支付剩余时间

@property (strong, nonatomic) NSString* playName;
@property (strong, nonatomic) NSString* playImg;
@property (strong, nonatomic) NSString* playTime;
@property (strong, nonatomic) NSString* address;

@end
