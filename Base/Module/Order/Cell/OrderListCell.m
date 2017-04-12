//
//  OrderListCell.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderListCell.h"
#import "NSString+Extension.h"
#import "UIButton+HYButtons.h"

@interface OrderListCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *orderNumLbl;
@property (weak, nonatomic) IBOutlet UIImageView *typeImgV;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *lbl1;
@property (weak, nonatomic) IBOutlet UILabel *lbl2;
@property (weak, nonatomic) IBOutlet UILabel *lbl3;
@property (weak, nonatomic) IBOutlet UILabel *lbl4;

@property (weak, nonatomic) IBOutlet UILabel *statuLbl;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation OrderListCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTheaterCell:(id)model {
    
    self.typeImgV.image = ImageNamed(@"订单类型_话剧");
    self.typeLbl.text = @"演出";
    self.lbl4.hidden = NO;
    
    //TODO:跳到评价页面，传递model和commentType
    
}

-(void)configDeriveCell:(id)model {
    
    self.typeImgV.image = ImageNamed(@"订单类型_商品");
    self.typeLbl.text = @"商品";
    self.lbl4.hidden = YES;
    
    self.titleLbl.text = model[@"goods_name"];
    self.orderNumLbl.text = model[@"order_sn"];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model[@"thumb_img"]] placeholderImage:ImageNamed(@"elephant")];
    self.lbl1.text = model[@"exchange_place"];
    self.lbl2.text = [NSString stringWithFormat:@"数量: %ld个",[model[@"goods_num"] integerValue]];
    self.lbl3.text = [NSString stringWithFormat:@"总价: %ld积分",[model[@"exchange_total_price"] integerValue]];
    
    NSArray* status = @[@"待领取",@"待评价",@"已完成"];
    NSInteger statu = [model[@"order_status"] integerValue];
    self.statuLbl.text = status[statu-1];
    if (statu == 2) {
        self.leftBtn.hidden = YES;
        self.rightBtn.hidden = NO;
        [self.rightBtn setTitle:@"去评价" forState:(UIControlStateNormal)];
        self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
            
            if (self.commentBlock) {
                self.commentBlock(model);
            }
            return [RACSignal empty];
        }];
    }else if (statu == 3){
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

-(void)configYearCardCell:(id)model {
    
    self.typeImgV.image = ImageNamed(@"订单类型_年卡");
    self.typeLbl.text = @"年卡";
    self.lbl4.hidden = YES;

    self.titleLbl.text = @"飞象卡1+1家庭年票";
    self.orderNumLbl.text = [model[@"order_id"] stringValue];
    self.lbl1.text = [NSString stringWithFormat:@"卡号: %@",model[@"order_sn"]];
    self.lbl2.text = [NSString stringWithFormat:@"数量: %@张",model[@"count"]];
    self.lbl3.text = [NSString stringWithFormat:@"总价: ¥%@",model[@"payable_amount"]];
    
    NSInteger payStatus = [model[@"pay_status"] integerValue];
    /*  payStatus
     define('PAY_STATUS_UNPAID', '0'); //未付款
     define('PAY_STATUS_PAID', '1'); //已付款
     define('PAY_STATUS_FAIL', '2'); //付款失败
     define('PAY_STATUS_REFUND', '3'); //已退款
     define('PAY_STATUS_EXPIRE', '5'); //已过期
     */
    BOOL isBind = [model[@"is_bind"] boolValue];
    switch (payStatus) {
        case 0:
        {
            self.statuLbl.text = @"待付款";
            self.leftBtn.hidden = YES;
            [self.rightBtn setTitle:@"去支付" forState:UIControlStateNormal];
            [self.rightBtn setRedStyle];
            self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                
                return [RACSignal empty];
            }];
        }
        case 1:
        {
            self.statuLbl.text = @"已付款";
            if (isBind) {
                self.leftBtn.hidden = YES;
                [self.rightBtn setTitle:@"退款" forState:UIControlStateNormal];
                self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    //TODO:退款
                    APPROUTE(kOrderRefundController);
                    return [RACSignal empty];
                }];
            }else{
                self.leftBtn.hidden = NO;
                [self.leftBtn setTitle:@"退款" forState:UIControlStateNormal];
                self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    //TODO:退款
                    APPROUTE(kOrderRefundController);
                    return [RACSignal empty];
                }];
                [self.rightBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
                self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
                    //TODO:绑定
                    APPROUTE(kYearCardBindController);
                    return [RACSignal empty];
                }];
            }
        }
        case 2:
        {
            self.statuLbl.text = @"已使用";

        }
        case 3:
        {
            self.statuLbl.text = @"已退款";

        }
        case 5:
        {
            self.statuLbl.text = @"已过期";
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
