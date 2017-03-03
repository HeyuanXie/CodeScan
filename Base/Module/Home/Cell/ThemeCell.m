//
//  ThemeCell.m
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ThemeCell.h"

@interface ThemeCell()

@property(nonatomic,copy)void(^setStatuLbl)(UIColor* color);

@end

@implementation ThemeCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

+(CGFloat)height {
    return 66;
}

-(void)configThemeCell:(id)model {
    @weakify(self);
    self.setStatuLbl = ^(UIColor* color){
        @strongify(self);
        [HYTool configViewLayer:self.statuLbl withColor:color];
        [HYTool configViewLayer:self.statuLbl size:10];
        self.statuLbl.textColor = color;
    };
    
    NSString* statu = model[@"statu"];
    if ([statu isEqualToString:@"0"]) {
        self.setStatuLbl([UIColor hyBarTintColor]);
    }else{
        self.setStatuLbl(defaultSelectColor);
    }
    
    //TODO:
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
