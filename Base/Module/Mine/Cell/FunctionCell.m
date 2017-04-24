//
//  FunctionCell.m
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "FunctionCell.h"

@implementation FunctionCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configFunctionCell:(id)model {
    self.imgV.image = ImageNamed(model[@"image"]);
    self.titleLbl.text = model[@"title"];
    [self setDetailBlock:^{
        //TODO:
        DLog(@"%@",model[@"title"]);
    }];
}

- (IBAction)detailAction:(id)sender {
    if (self.detailBlock) {
        self.detailBlock();
    }
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
