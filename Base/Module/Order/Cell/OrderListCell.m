//
//  OrderListCell.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderListCell.h"
#import "NSString+Extension.h"
#import "TheaterModel.h"

@interface OrderListCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;

@end

@implementation OrderListCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTheaterCell:(id)model orderStatu:(NSInteger)orderStatu {
    
    NSInteger payStatus = [model[@"pay_status"] integerValue];
    NSInteger leftTime = [model[@"time_left"] integerValue];
    
    self.typeImgV.image = ImageNamed(@"订单类型_话剧");
    self.typeLbl.text = @"演出";
    self.orderNumLbl.text = leftTime == 0 ? [NSString stringWithFormat:@"订单号: %@",model[@"order_sn"]] : nil;
    self.lbl4.hidden = NO;
    
    TheaterModel* theater = [TheaterModel yy_modelWithDictionary:model];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:theater.picurl] placeholderImage:nil];
    self.titleLbl.text = [[theater.playName stringByReplacingOccurrencesOfString:@"《" withString:@""] stringByReplacingOccurrencesOfString:@"》" withString:@""];
    self.lbl1.text = [NSString stringWithFormat:@"地点: %@",theater.theaterName];
    self.lbl2.text = [NSString stringWithFormat:@"上映: %@",[HYTool dateStringWithString:theater.playTime inputFormat:nil outputFormat:@"yyyy-MM-dd HH:mm"]];
    self.lbl3.text = [NSString stringWithFormat:@"数量: %ld",theater.num.integerValue];
    self.lbl4.text = [NSString stringWithFormat:@"总价: ¥%@",theater.payableAmount];
    
    switch (orderStatu) {
        case 0:
        {
            self.statuLbl.text = @"已付款";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
            [self.rightBtn setBlueStyle];
            self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                //TODO:退款
                APPROUTE(([NSString stringWithFormat:@"%@?orderId=%ld&contentType=%d",kOrderRefundController,[model[@"order_id"] integerValue],0]));
                return [RACSignal empty];
            }];
            break;
        }
        case 1:
        {
            self.statuLbl.text = @"待付款";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"去支付" forState:UIControlStateNormal];
            [self.rightBtn setRedStyle];
            self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                if (self.payContinueBlock) {
                    self.payContinueBlock(model);
                }
                return [RACSignal empty];
            }];
            
            if (leftTime==0) {
                self.statuLbl.text = @"支付超时";
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"已取消" forState:UIControlStateNormal];
                [self.rightBtn setGrayStyle];
            }
            break;
        }
        case 2:
        {
            self.statuLbl.text = @"待评价";
            break;
        }
        case 3:
        {
            self.statuLbl.text = @"已退款";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            self.lbl4.text = [NSString stringWithFormat:@"退款金额: ¥%@",theater.payableAmount];
            break;
        }
        case 5:
        {
            self.statuLbl.text = @"已过期";
            break;
        }
    }
    //TODO:跳到评价页面，传递model和commentType
    
}

-(void)configDeriveCell:(id)model orderStatu:(NSInteger)orderStatu {
    
    self.typeImgV.image = ImageNamed(@"订单类型_商品");
    self.typeLbl.text = @"商品";
    self.lbl4.hidden = YES;
    [self.rightBtn setBackgroundColor:[UIColor whiteColor]];
    [self.rightBtn setTitleColor:[UIColor hyBlueTextColor] forState:UIControlStateNormal];
    self.rightBtn.layer.borderColor = [UIColor hyBlueTextColor].CGColor;
    
    self.titleLbl.text = model[@"goods_name"];
    self.orderNumLbl.text = [NSString stringWithFormat:@"订单号: %@",model[@"order_sn"]];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model[@"thumb_img"]] placeholderImage:ImageNamed(@"elephant")];
    self.lbl1.text = model[@"exchange_place"];
    self.lbl2.text = [NSString stringWithFormat:@"数量: %ld个",[model[@"goods_num"] integerValue]];
    self.lbl3.text = [NSString stringWithFormat:@"总价: %ld积分",[model[@"exchange_total_price"] integerValue]];
    
    NSArray* status = @[@"待领取",@"待评价",@"已完成"];
    NSInteger statu = orderStatu-1;
    self.statuLbl.text = status[statu];


    if (statu == 1) {
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
        [self.rightBtn setTitle:@"去评价" forState:(UIControlStateNormal)];
        self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            if (self.commentBlock) {
                self.commentBlock(model);
            }
            return [RACSignal empty];
        }];
    }else if (statu == 2){
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
        [self.rightBtn setTitle:@"再次兑换" forState:(UIControlStateNormal)];
        self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            APPROUTE(([NSString stringWithFormat:@"%@?id=%ld",kDeriveDetailController,[model[@"goods_id"] integerValue]]));
            return [RACSignal empty];
        }];
    }else{
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }
}

-(void)configYearCardCell:(id)model orderStatu:(NSInteger)orderStatu {

    NSInteger leftTime = [model[@"time_left"] integerValue];
    BOOL isBind = [model[@"is_bind"] boolValue];

    self.typeImgV.image = ImageNamed(@"订单类型_年卡");
    self.typeLbl.text = @"年卡";
    self.lbl4.hidden = YES;

    self.titleLbl.text = @"飞象卡1+1家庭年票";
    self.orderNumLbl.text = leftTime == 0 ? [NSString stringWithFormat:@"订单号: %@",model[@"order_sn"]] : nil;
    self.lbl1.text = [NSString stringWithFormat:@"卡号: %@",model[@"card_sn"]];
    self.lbl2.text = [NSString stringWithFormat:@"数量: %@张",model[@"count"]];
    self.lbl3.text = [NSString stringWithFormat:@"总价: ¥%@",model[@"payable_amount"]];
    
    switch (orderStatu-1) {
        case 0:
        {
            [self.leftBtn setBlueStyle];
            [self.rightBtn setBlueStyle];
            self.statuLbl.text = @"已付款";
            if (isBind) {
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = YES;
                [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
                self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    //TODO:退款
                    APPROUTE(([NSString stringWithFormat:@"%@?orderId=%ld&contentType=%d",kOrderRefundController,[model[@"order_id"] integerValue],1]));
                    return [RACSignal empty];
                }];
            }else{
                self.leftBtn.hidden = NO;
                [self.leftBtn setTitle:@"退款" forState:UIControlStateNormal];
                self.leftBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    //TODO:退款
                    APPROUTE(([NSString stringWithFormat:@"%@?orderId=%ld&contentType=%d",kOrderRefundController,[model[@"order_id"] integerValue],1]));
                    return [RACSignal empty];
                }];
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
                self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    APPROUTE(([NSString stringWithFormat:@"%@?cardNum=%@&cardPassword=%@",kYearCardBindController,model[@"card_sn"],model[@"card_password"]]));
                    return [RACSignal empty];
                }];
            }
            break;
        }
        case 1:
        {
            self.statuLbl.text = @"待付款";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"去支付" forState:UIControlStateNormal];
            [self.rightBtn setRedStyle];
            self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                if (self.payContinueBlock) {
                    self.payContinueBlock(model);
                }
                return [RACSignal empty];
            }];
            
            if (leftTime==0) {
                self.statuLbl.text = @"支付超时";
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"已取消" forState:UIControlStateNormal];
                [self.rightBtn setGrayStyle];
            }
            break;
        }
        case 2:
        {
            self.statuLbl.text = @"已使用";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;

            break;
        }
        case 3:
        {
            self.statuLbl.text = @"已退款";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            self.lbl1.text = [NSString stringWithFormat:@"数量: %@张",model[@"count"]];
            self.lbl2.text = [NSString stringWithFormat:@"退款金额: ¥%@",model[@"payable_amount"]];
            self.lbl3.text = @"";
            break;
        }
        case 5:
        {
            self.statuLbl.text = @"已过期";
            self.leftBtn.hidden = YES;
            [self.rightBtn setGrayStyle];
            [self.rightBtn setTitle:@"已取消" forState:UIControlStateNormal];
            self.rightBtn.userInteractionEnabled = YES;
            break;
        }
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [HYTool configViewLayer:self.leftBtn withColor:[UIColor hyBarTintColor]];
    [HYTool configViewLayer:self.rightBtn withColor:[UIColor hyBarTintColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
