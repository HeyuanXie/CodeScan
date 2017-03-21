//
//  WeekEndCell.m
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "WeekEndCell.h"

@interface WeekEndCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (weak, nonatomic) IBOutlet UIButton *supportBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation WeekEndCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (UIButton* btn in @[self.supportBtn,self.commentBtn]) {
        [HYTool configViewLayer:btn withColor:RGB(191, 191, 191, 1.0)];
        [HYTool configViewLayer:btn size:10];
    }
    [HYTool configViewLayer:self.imgV];
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configWeekEndCell:(id)model {
    [self.supportBtn bk_whenTapped:^{
        //TODO:点赞
        
    }];
    [self.commentBtn bk_whenTapped:^{
        //TODO:评论
        
    }];
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
