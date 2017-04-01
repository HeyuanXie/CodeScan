//
//  OrderDetailHeadCell.m
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderDetailHeadCell.h"
#import "NSString+Extension.h"

@interface OrderDetailHeadCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVWidth; //(81-62)

@property (weak, nonatomic) IBOutlet UIImageView *rightImgV;    //向右的箭头

@property (weak, nonatomic) IBOutlet UILabel *firstLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondLbl;
@property (weak, nonatomic) IBOutlet UILabel *thirdLbl;
@property (weak, nonatomic) IBOutlet UILabel *forthLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLblLeading;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLblTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *thirdLblTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *forthLblTop;


@end

@implementation OrderDetailHeadCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTheaterHeadCell:(id)model {

    self.firstLbl.text = @"丑小鸭";
    self.secondLbl.text = @"2017-2-23 周四 19:30";
    self.thirdLbl.text = @"东莞市玉兰大剧场";
    
    NSString* text = [NSString stringWithFormat:@"¥%@(%d张)",@"340",3];
    self.forthLbl.attributedText = [text addAttribute:@[NSFontAttributeName,NSFontAttributeName,NSForegroundColorAttributeName] values:@[[UIFont systemFontOfSize:14],[UIFont systemFontOfSize:14],RGB(78, 78, 78, 1.0)] subStrings:@[@"¥",[NSString stringWithFormat:@"(%d张)",3],[NSString stringWithFormat:@"(%d张)",3]]];
}

-(void)configLectureHeadCell:(id)model {
    self.imgVWidth.constant = 42;
    self.imgV.hidden = YES;
    
    self.firstLblLeading.constant = -40;
    self.firstLbl.text = [NSString stringWithFormat:@"主题： 0~3岁孩子体格发育"];
    self.secondLbl.text = @"2017-2-29 19:50";
    self.thirdLbl.text = @"主讲: 都教授 东莞玉兰大剧院";
    
    NSString* text = [NSString stringWithFormat:@"¥%@",@"15"];
    self.forthLbl.attributedText = [text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:14]] subStrings:@[@"¥"]];
}

-(void)configDeriveHeadCell:(id)model {
    if (model == nil) {
        return;
    }
    self.rightImgV.hidden = YES;
    self.thirdLbl.hidden = YES;
    self.forthLbl.hidden = YES;
    self.secondLblTop.constant = 10;
    
    if (![model[@"thumb_img"] isEqualToString:@""]) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:model[@"thumb_img"]] placeholderImage:nil];
    }
    self.firstLbl.text = model[@"goods_name"];
    NSString* price = [NSString stringWithFormat:@"%ld",[model[@"exchange_total_price"] integerValue]];
    NSString* text = [NSString stringWithFormat:@"%@积分",price];
    self.secondLbl.attributedText = [text addAttribute:@[NSFontAttributeName,NSForegroundColorAttributeName] values:@[[UIFont systemFontOfSize:19],[UIColor hyRedColor]] subStrings:@[price,price]];
}

-(void)configYearCardHeadCell:(id)model {
    self.imgVWidth.constant = 106;
    self.thirdLblTop.constant = 10;
    self.forthLbl.hidden = YES;
    
    self.firstLbl.text = @"飞象卡1+1家庭年票";
    self.secondLbl.text = @"一年12次观剧机会,每次限制两人";
    
    NSString* text = [NSString stringWithFormat:@"¥%@",@"99"];
    self.thirdLbl.textColor = [UIColor hyRedColor];
    self.thirdLbl.font = [UIFont systemFontOfSize:19];
    self.thirdLbl.attributedText = [text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:14]] subStrings:@[@"¥"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
