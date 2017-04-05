//
//  TheaterListCell.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterListCell.h"
#import "TheaterModel.h"

@implementation TheaterListCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTheaterListCell:(id)model {
    
    TheaterModel* theater = (TheaterModel*)model;
    @weakify(self);
    [self.ticketBtn bk_whenTapped:^{
        @strongify(self);
        if (self.ticketBtnClick) {
            self.ticketBtnClick(theater);
        }
    }];
    [self.collectBtn bk_whenTapped:^{
        @strongify(self);
        if (self.collectBtnClick) {
            self.collectBtnClick(theater);
        }
    }];
    
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:theater.picurl] placeholderImage:ImageNamed(@"elephant")];
    self.titleLbl.text = theater.playName;
    self.typeLbl.text = theater.subTitle;
    self.timeLbl.text = [NSString stringWithFormat:@"时长: %@分钟",theater.pctime];
    self.dateLbl.text = [NSString stringWithFormat:@"上映: %@",theater.sydate];
    
    self.priceLbl.text = [NSString stringWithFormat:@"¥%@ - ¥%@",theater.pricel,theater.priceh];
    if (!theater.priceh) {
        self.priceLbl.text = [NSString stringWithFormat:@"¥%@",theater.pricel];
    }
    NSMutableAttributedString* mAttStr = [[NSMutableAttributedString alloc] initWithString:self.priceLbl.text];
    NSArray* ranges = [self rangeOfSubString:@"¥" inString:self.priceLbl.text];
    for (NSString* rangeStr in ranges) {
        NSRange range = NSRangeFromString(rangeStr);
        [mAttStr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:range];
    }
    self.priceLbl.attributedText = mAttStr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [HYTool configViewLayer:self.backView];
    [HYTool configViewLayer:self.imgV];
    [HYTool configViewLayer:self.ticketBtn withColor:[UIColor hyBlueTextColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


#pragma mark - private methods 
//MARK: 得到一个子串所有的range
- (NSArray *)rangeOfSubString:(NSString *)subStr inString:(NSString *)string {
    
    NSMutableArray *rangeArray = [NSMutableArray array];
    
    NSString *string1 = [string stringByAppendingString:subStr];
    
    NSString *temp;
    
    for (int i = 0; i < string.length; i ++) {
        
        temp = [string1 substringWithRange:NSMakeRange(i, subStr.length)];
        
        if ([temp isEqualToString:subStr]) {
            
            NSRange range = {i,subStr.length};
            
            [rangeArray addObject:NSStringFromRange(range)];
            
        }
        
    }
    
    return rangeArray;
    
}

@end
