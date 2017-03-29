//
//  HomeDescCell.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HomeDescCell.h"
#import "NSString+HYUtilities.h"

@interface HomeDescCell ()

@property (weak, nonatomic) IBOutlet UILabel *descLbl;

@end

@implementation HomeDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configDescCell:(id)model {
    
    if (model) {
        self.descLbl.text = [NSString stringWithHtmlString:model[@"card_content"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
