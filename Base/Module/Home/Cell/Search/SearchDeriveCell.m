//
//  SearchDeriveCell.m
//  Base
//
//  Created by admin on 2017/3/23.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SearchDeriveCell.h"
#import "NSString+Extension.h"

@interface SearchDeriveCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@property (weak, nonatomic) IBOutlet UILabel *priceLb;

@end

@implementation SearchDeriveCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configSearchDeriveCell:(id)model keyword:(NSString*)word {
    NSString* title = [NSString stringWithFormat:@"测试商品搜索%@",word];
    self.titleLbl.attributedText = [title addAttribute:@[NSForegroundColorAttributeName] values:@[[UIColor hyRedColor]] subStrings:@[word]];
    
    NSString* price = self.priceLb.text;
    self.priceLb.attributedText = [price addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:13]] subStrings:@[@"积分"]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
