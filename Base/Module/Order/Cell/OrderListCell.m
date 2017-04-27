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

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *leftRightBtnWidths;

@property (strong, nonatomic) IBOutletCollection(NSLayoutConstraint) NSArray *leftRightBtnHeights;

@end

@implementation OrderListCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTheaterCell:(id)model orderStatu:(NSInteger)orderStatu {
    
    NSInteger payStatus = [model[@"pay_status"] integerValue];  //0:未支付，3:已退款
    NSInteger orderStatus = [model[@"order_status"] integerValue];  //待使用(0)、已使用(1)、待评价(4)、已过期(关闭)(5)
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
        case 1://全部
        {
            if (payStatus == 0) {
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
                return;
            }
            if (payStatus == 3) {
                self.statuLbl.text = @"退款成功";
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = YES;
                self.lbl4.text = [NSString stringWithFormat:@"退款金额: ¥%@",theater.payableAmount];
                return;
            }
            if (orderStatus == 0) {
                self.statuLbl.text = @"待使用";
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
                [self.rightBtn setBlueStyle];
                self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    //TODO:退款
                    APPROUTE(([NSString stringWithFormat:@"%@?orderId=%ld&contentType=%d",kOrderRefundController,[model[@"order_id"] integerValue],0]));
                    return [RACSignal empty];
                }];
                if ([model[@"is_print"] integerValue] == 1) {
                    [self.rightBtn setGrayStyle];
                    [self.rightBtn bk_whenTapped:^{
                        if (self.noRefundBlock) {
                            self.noRefundBlock();
                        }
                    }];
                }
                return;
            }
            if (orderStatus == 4) {
                self.statuLbl.text = @"待评价";
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = NO;
                [self.rightBtn setTitle:@"去评价" forState:(UIControlStateNormal)];
                self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    
                    if (self.commentBlock) {
                        self.commentBlock(model);
                    }
                    return [RACSignal empty];
                }];
                return;
            }
            break;
        }
        case 2:
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
        case 3:
        {
            self.statuLbl.text = @"待使用";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
            [self.rightBtn setBlueStyle];
            self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                //TODO:退款
                APPROUTE(([NSString stringWithFormat:@"%@?orderId=%ld&contentType=%d",kOrderRefundController,[model[@"order_id"] integerValue],0]));
                return [RACSignal empty];
            }];
            if ([model[@"is_print"] integerValue] == 1) {
                [self.rightBtn setGrayStyle];
                [self.rightBtn bk_whenTapped:^{
                    if (self.noRefundBlock) {
                        self.noRefundBlock();
                    }
                }];
            }
            break;
        }
        case 4:
        {
            self.statuLbl.text = @"待评价";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = NO;
            [self.rightBtn setTitle:@"去评价" forState:(UIControlStateNormal)];
            self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                
                if (self.commentBlock) {
                    self.commentBlock(model);
                }
                return [RACSignal empty];
            }];
            break;
        }
        case 5:
        {
            self.statuLbl.text = @"退款成功";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            self.lbl4.text = [NSString stringWithFormat:@"退款金额: ¥%@",theater.payableAmount];
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
            //TODO:model[@"source_url"]没有
            APPROUTE(([NSString stringWithFormat:@"%@?id=%ld&sourceUrl=%@",kDeriveDetailController,[model[@"goods_id"] integerValue],model[@"source_url"]]));
            return [RACSignal empty];
        }];
    }else{
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = YES;
    }
}

-(void)configYearCardCell:(id)model orderStatu:(NSInteger)orderStatu {

    NSInteger leftTime = [model[@"time_left"] integerValue];
    NSInteger payStatus = [model[@"pay_status"] integerValue];
    BOOL isBind = [model[@"is_bind"] boolValue];

    self.typeImgV.image = ImageNamed(@"订单类型_年卡");
    self.typeLbl.text = @"年卡";
    self.lbl4.hidden = YES;

    self.titleLbl.text = @"飞象卡1+1家庭年票";
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model[@"thumb"]] placeholderImage:nil];
    self.orderNumLbl.text = leftTime == 0 ? [NSString stringWithFormat:@"订单号: %@",model[@"order_sn"]] : nil;
    self.lbl1.text = [NSString stringWithFormat:@"卡号: %@",model[@"card_sn"]];
    self.lbl2.text = [NSString stringWithFormat:@"数量: %@张",model[@"count"]];
    self.lbl3.text = [NSString stringWithFormat:@"总价: ¥%@",model[@"payable_amount"]];
    
    if (IS_IPHONE_5s) {
        self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:14];
        for (NSLayoutConstraint* width in self.leftRightBtnWidths) {
            width.constant = 60;
        }
        for (NSLayoutConstraint* height in self.leftRightBtnHeights) {
            height.constant = 25;
        }
    }else{
        self.leftBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        self.rightBtn.titleLabel.font = [UIFont systemFontOfSize:16];
        for (NSLayoutConstraint* width in self.leftRightBtnWidths) {
            width.constant = 70;
        }
        for (NSLayoutConstraint* height in self.leftRightBtnHeights) {
            height.constant = 30;
        }
    }
    
    switch (orderStatu) {
        case 1://全部
        {
            if (payStatus == 0) {
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
                return;
            }
            if (payStatus == 3) {
                self.statuLbl.text = @"退款成功";
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = YES;
                self.lbl1.text = [NSString stringWithFormat:@"数量: %@张",model[@"count"]];
                self.lbl2.text = [NSString stringWithFormat:@"退款金额: ¥%@",model[@"payable_amount"]];
                self.lbl3.text = @"";
                return;
            }
            if (isBind) {
                self.statuLbl.text = @"已使用";
                self.leftBtn.hidden = YES;
                self.rightBtn.hidden = YES;
                return;
            }else{
                [self.leftBtn setBlueStyle];
                [self.rightBtn setBlueStyle];
                self.statuLbl.text = @"待使用";
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
                return;
            }
            break;
        }
        case 2:
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
        case 3:
        {
            [self.leftBtn setBlueStyle];
            [self.rightBtn setBlueStyle];
            self.statuLbl.text = @"待使用";
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
        case 4:
        {
            self.statuLbl.text = @"已使用";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            break;
        }
        case 5:
        {
            self.statuLbl.text = @"退款成功";
            self.leftBtn.hidden = YES;
            self.rightBtn.hidden = YES;
            self.lbl1.text = [NSString stringWithFormat:@"数量: %@张",model[@"count"]];
            self.lbl2.text = [NSString stringWithFormat:@"退款金额: ¥%@",model[@"payable_amount"]];
            self.lbl3.text = @"";
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
