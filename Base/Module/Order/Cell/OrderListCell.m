//
//  OrderListCell.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderListCell.h"

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
    
    switch ([model[@"statu"] integerValue]) {
        case 0:
        {
            self.statuLbl.text = @"待使用";
            [self.rightBtn setTitle:@"去使用" forState:UIControlStateNormal];
            [self.rightBtn bk_whenTapped:^{
                //TODO:跳到订单详情页(入场二维码)
            }];
            break;
        }
        case 1:
        {
            self.statuLbl.text = @"已完成";
            self.rightBtn.hidden = YES;
            break;
        }
        case 2:
        {
            self.statuLbl.text = @"待评价";
            [self.rightBtn bk_whenTapped:^{
                //TODO:跳到评价页面
            }];
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
