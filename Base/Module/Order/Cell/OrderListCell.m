//
//  OrderListCell.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderListCell.h"
#import "NSString+Extension.h"

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
    self.lbl4.hidden = NO;
    
    [self.leftBtn bk_whenTapped:^{
        APPROUTE(kCommentViewController);
    }];
    [self.rightBtn bk_whenTapped:^{
        APPROUTE(kCommentListController);
    }];
}

-(void)configDeriveCell:(id)model {
    
    self.typeImgV.image = ImageNamed(@"订单类型_商品");
    self.lbl4.hidden = YES;
    
    self.lbl1.text = @"领取地点: 东莞玉兰大剧场";
    self.lbl2.text = @"数量: 2张";
    self.lbl3.text = @"总价: ¥99";
}

-(void)configYearCardCell:(id)model {
    
    self.typeImgV.image = ImageNamed(@"订单类型_年卡");
    self.lbl4.hidden = YES;
    
    self.lbl1.text = @"卡号: 12344565";
    self.lbl2.text = @"数量: 2张";
    self.lbl3.text = @"总价: ¥99";
    
    //测试支付倒计时
    NSString* time = @" 剩余支付时间:14分20秒";
    self.orderNumLbl.attributedText = [time attributeStringWithAttachment:CGRectMake(0, -2, 15, 15) fontSize:13 textColor:RGB(127, 127, 127, 1.0) index:0 imageName:@"支付倒计时"];
    
    switch ([model[@"statu"] integerValue]) {
        case 0:
        {
            self.statuLbl.text = @"已付款";
            [self.leftBtn setTitle:@"退款" forState:UIControlStateNormal];
            [self.leftBtn bk_whenTapped:^{
                //TODO:退款
                
            }];
            [self.rightBtn setTitle:@"立即绑定" forState:UIControlStateNormal];
            [self.rightBtn bk_whenTapped:^{
                //TODO:绑定
                
            }];
        }
        case 1:
        {
            self.statuLbl.text = @"代付款";
        }
        case 2:
        {
            self.statuLbl.text = @"已使用";

        }
        case 3:
        {
            self.statuLbl.text = @"退款";

        }
//        case 1:
//        {
//            self.statuLbl.text = @"待使用";
//            [self.rightBtn setTitle:@"去使用" forState:UIControlStateNormal];
//            [self.rightBtn bk_whenTapped:^{
//                //TODO:跳到订单详情页(入场二维码)
//            }];
//            break;
//        }
//        case 2:
//        {
//            self.statuLbl.text = @"已完成";
//            self.rightBtn.hidden = YES;
//            break;
//        }
//        case 3:
//        {
//            self.statuLbl.text = @"待评价";
//            [self.rightBtn bk_whenTapped:^{
//                //TODO:跳到评价页面
//            }];
//            break;
//        }
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
