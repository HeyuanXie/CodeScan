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


@end

@implementation DeriveListCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configListCellWithLeft:(id)leftModel right:(id)rightModel {
    [self configLeftView:leftModel];
    [self configRightView:rightModel];
}

-(void)configLeftView:(id)model {
    ((UIImageView*)[self.leftView viewWithTag:1000]).image = ImageNamed(@"baidi");
    ((UILabel*)[self.leftView viewWithTag:1001]).text = @"白雪公主连衣裙";
    ((UILabel*)[self.leftView viewWithTag:1002]).text = @"1200积分";
    [((UIButton*)[self.leftView viewWithTag:1003]) bk_whenTapped:^{
        if (self.exchangeClick) {
            self.exchangeClick(model);
        }
    }];
    
    [self.leftView bk_whenTapped:^{
        if (self.itemClick) {
            self.itemClick(model);
        }
    }];
}
-(void)configRightView:(id)model {
    if (model == nil) {
        self.rightView.hidden = YES;
        return;
    }
    ((UIImageView*)[self.rightView viewWithTag:1000]).image = ImageNamed(@"baidi");
    ((UILabel*)[self.rightView viewWithTag:1001]).text = @"白雪公主连衣裙";
    ((UILabel*)[self.rightView viewWithTag:1002]).text = @"1200积分";
    [((UIButton*)[self.rightView viewWithTag:1003]) bk_whenTapped:^{
        if (self.exchangeClick) {
            self.exchangeClick(model);
        }
    }];
    
    [self.rightView bk_whenTapped:^{
        if (self.itemClick) {
            self.itemClick(model);
        }
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    UIButton* leftBtn = [self.leftView viewWithTag:1003];
    UIButton* rightBtn = [self.rightView viewWithTag:1003];
    [HYTool configViewLayer:leftBtn withColor:RGB(107, 179, 246, 1.0)];
    [HYTool configViewLayer:rightBtn withColor:RGB(107, 179, 246, 1.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
