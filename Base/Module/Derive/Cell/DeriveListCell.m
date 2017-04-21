//
//  DeriveListCell.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "DeriveListCell.h"
#import "NSString+Extension.h"

@interface DeriveListCell ()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *rightView;
@property (weak, nonatomic) IBOutlet UIButton *leftBtn;
@property (weak, nonatomic) IBOutlet UIButton *rightBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftExchangeBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightExcahngeBtnWidth;
@end

@implementation DeriveListCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configListCellWithLeft:(DeriveModel*)leftModel right:(DeriveModel*)rightModel isCollect:(BOOL)isCollect {
    
    [self configLeftView:leftModel isCollect:isCollect];
    [self configRightView:rightModel isCollect:isCollect];
    if (isCollect) {
        self.leftExchangeBtnWidth.constant = 70;
        self.rightExcahngeBtnWidth.constant = 70;
    }
}

-(void)configLeftView:(DeriveModel*)model isCollect:(BOOL)isCollect {
    
    UIImageView* productImg = (UIImageView*)[self.leftView viewWithTag:1000];
    UILabel* nameLbl = (UILabel*)[self.leftView viewWithTag:1001];
    UILabel* priceLbl = (UILabel*)[self.leftView viewWithTag:1002];
    UIButton* exchangeBtn = (UIButton*)[self.leftView viewWithTag:1003];
    UIImageView* noneImg = (UIImageView*)[self.leftView viewWithTag:1004];
    
    [productImg sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:ImageNamed(@"baidi")];
    nameLbl.text = model.goodName;
    priceLbl.text = [NSString stringWithFormat:@"%ld积分",model.shopPrice.integerValue];
    if (IS_IPHONE_5s) {
        nameLbl.font = [UIFont systemFontOfSize:13];
        priceLbl.font = [UIFont systemFontOfSize:17];
        priceLbl.attributedText = [priceLbl.text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:12]] subStrings:@[@"积分"]];
    }else{
        nameLbl.font = [UIFont systemFontOfSize:14];
        priceLbl.font = [UIFont systemFontOfSize:19];
        priceLbl.attributedText = [priceLbl.text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:14]] subStrings:@[@"积分"]];
    }
    exchangeBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        if (self.exchangeClick) {
            self.exchangeClick(model);
        }
        return [RACSignal empty];
    }];
    
    [exchangeBtn setTitle:(isCollect ? @"取消收藏" : @"兑换") forState:UIControlStateNormal];
    if (model.storeCount.integerValue == 0 && !isCollect) {
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


-(void)configRightView:(DeriveModel*)model isCollect:(BOOL)isCollect {
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
    priceLbl.text = [NSString stringWithFormat:@"%ld积分",model.shopPrice.integerValue];
    if (IS_IPHONE_5s) {
        nameLbl.font = [UIFont systemFontOfSize:13];
        priceLbl.font = [UIFont systemFontOfSize:17];
        priceLbl.attributedText = [priceLbl.text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:12]] subStrings:@[@"积分"]];
    }else{
        nameLbl.font = [UIFont systemFontOfSize:14];
        priceLbl.font = [UIFont systemFontOfSize:19];
        priceLbl.attributedText = [priceLbl.text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:14]] subStrings:@[@"积分"]];
    }
    exchangeBtn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        if (self.exchangeClick) {
            self.exchangeClick(model);
        }
        return [RACSignal empty];
    }];
    
    [exchangeBtn setTitle:(isCollect ? @"取消收藏" : @"兑换") forState:UIControlStateNormal];
    if (model.storeCount.integerValue == 0 && !isCollect) {
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
