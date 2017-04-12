//
//  DeriveListCell.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "DeriveListCell.h"

@interface DeriveListCell ()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;

@end

@implementation DeriveListCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configListCellWithLeft:(DeriveModel*)leftModel right:(DeriveModel*)rightModel {
    
    [self configLeftView:leftModel];
    [self configRightView:rightModel];
}

-(void)configLeftView:(DeriveModel*)model {
    
    UIImageView* productImg = (UIImageView*)[self.leftView viewWithTag:1000];
    UILabel* nameLbl = (UILabel*)[self.leftView viewWithTag:1001];
    UILabel* priceLbl = (UILabel*)[self.leftView viewWithTag:1002];
    UIButton* exchangeBtn = (UIButton*)[self.leftView viewWithTag:1003];
    UIImageView* noneImg = (UIImageView*)[self.leftView viewWithTag:1004];
    
    [productImg sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:ImageNamed(@"baidi")];
    nameLbl.text = model.goodName;
    priceLbl.text = [NSString stringWithFormat:@"%ld",model.shopPrice.integerValue];
    exchangeBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if (self.exchangeClick) {
            self.exchangeClick(model);
        }
        return [RACSignal empty];
    }];

    if (model.storeCount.integerValue == 0) {
        noneImg.hidden = NO;
        [HYTool configViewLayer:exchangeBtn withColor:[UIColor colorWithString:@"bfbfbf"]];
        exchangeBtn.layer.borderWidth = 1;
        [exchangeBtn setTitleColor:[UIColor colorWithString:@"bfbfbf"] forState:UIControlStateNormal];
    }else{
        noneImg.hidden = YES;
        [HYTool configViewLayer:exchangeBtn withColor:RGB(107, 179, 246, 1.0)];
        exchangeBtn.layer.borderWidth = 1;
        [exchangeBtn setTitleColor:RGB(107, 179, 246, 1.0) forState:UIControlStateNormal];
    }
    self.leftBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        if (self.itemClick) {
            self.itemClick(model);
        }
        return [RACSignal empty];
    }];
}


-(void)configRightView:(DeriveModel*)model {
    if (model == nil) {
        self.rightView.hidden = YES;
        return;
    }else{
        self.rightView.hidden = NO;
    }
    
    UIImageView* productImg = (UIImageView*)[self.rightView viewWithTag:1000];
    UILabel* nameLbl = (UILabel*)[self.rightView viewWithTag:1001];
    UILabel* priceLbl = (UILabel*)[self.rightView viewWithTag:1002];
    UIButton* exchangeBtn = (UIButton*)[self.rightView viewWithTag:1003];
    UIImageView* noneImg = (UIImageView*)[self.rightView viewWithTag:1004];
    
    [productImg sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:ImageNamed(@"baidi")];
    nameLbl.text = model.goodName;
    priceLbl.text = [NSString stringWithFormat:@"%ld",model.shopPrice.integerValue];
    exchangeBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        if (self.exchangeClick) {
            self.exchangeClick(model);
        }
        return [RACSignal empty];
    }];
    
    if (model.storeCount.integerValue == 0) {
        noneImg.hidden = NO;
        [HYTool configViewLayer:exchangeBtn withColor:[UIColor colorWithString:@"bfbfbf"]];
        exchangeBtn.layer.borderWidth = 1;
        [exchangeBtn setTitleColor:[UIColor colorWithString:@"bfbfbf"] forState:UIControlStateNormal];
    }else{
        noneImg.hidden = YES;
        [HYTool configViewLayer:exchangeBtn withColor:RGB(107, 179, 246, 1.0)];
        exchangeBtn.layer.borderWidth = 1;
        [exchangeBtn setTitleColor:RGB(107, 179, 246, 1.0) forState:UIControlStateNormal];
    }
    self.rightBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        if (self.itemClick) {
            self.itemClick(model);
        }
        return [RACSignal empty];
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
