//
//  OrderListCell.h
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIButton+HYButtons.h"

@interface OrderListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderNumLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuLbl;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@property(nonatomic,copy)void (^payContinueBlock)(id model);
@property(nonatomic,copy)void (^noRefundBlock)();   //不能退款的回调
@property(nonatomic,copy)void (^commentBlock)(id model);

+(NSString*)identify;
-(void)configTheaterCell:(id)model orderStatu:(NSInteger)orderStatu;
-(void)configDeriveCell:(id)model orderStatu:(NSInteger)orderStatu;
-(void)configYearCardCell:(id)model orderStatu:(NSInteger)orderStatu;

@end
