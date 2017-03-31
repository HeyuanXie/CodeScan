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
    
    ((UIImageView*)[self.leftView viewWithTag:1000]).image = ImageNamed(@"baidi");
    if (![model.img isEqualToString:@""]) {
        [(UIImageView*)[self.leftView viewWithTag:1000] sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    }
    ((UILabel*)[self.leftView viewWithTag:1001]).text = model.goodName;
    ((UILabel*)[self.leftView viewWithTag:1002]).text = [NSString stringWithFormat:@"%ld",model.shopPrice.integerValue];
    
    ((UIButton*)[self.leftView viewWithTag:1003]).rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        
        if (self.exchangeClick) {
            self.exchangeClick(model);
        }
        return [RACSignal empty];
    }];
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
    ((UIImageView*)[self.rightView viewWithTag:1000]).image = ImageNamed(@"baidi");
    if (![model.img isEqualToString:@""]) {
        [((UIImageView*)[self.rightView viewWithTag:1000]) sd_setImageWithURL:[NSURL URLWithString:model.img] placeholderImage:nil];
    }
    ((UILabel*)[self.rightView viewWithTag:1001]).text = model.goodName;
    ((UILabel*)[self.rightView viewWithTag:1002]).text = [NSString stringWithFormat:@"%ld",model.shopPrice.integerValue];
    
    ((UIButton*)[self.rightView viewWithTag:1003]).rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
       
        if (self.exchangeClick) {
            self.exchangeClick(model);
        }
        return [RACSignal empty];
    }];

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
