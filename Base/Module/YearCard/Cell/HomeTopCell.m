//
//  HomeTopCell.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HomeTopCell.h"

@interface HomeTopCell ()

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;

@end

@implementation HomeTopCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTopCell:(id)model {
    if (model) {
        self.titleLbl.text = model[@"card_name"];
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];

    self.titleLbl.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
