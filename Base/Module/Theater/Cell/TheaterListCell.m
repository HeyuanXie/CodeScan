//
//  TheaterListCell.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterListCell.h"

@implementation TheaterListCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTheaterListCell:(id)model {
    
    @weakify(self);
    [self.ticketBtn bk_whenTapped:^{
        @strongify(self);
        if (self.ticketBtnClick) {
            self.ticketBtnClick(model);
        }
    }];
    
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
