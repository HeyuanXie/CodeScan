//
//  CommitOrderTopCell.m
//  Base
//
//  Created by admin on 2017/3/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CommitOrderTopCell.h"

@interface CommitOrderTopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@property (weak, nonatomic) IBOutlet UILabel *tagLbl1;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn1;

@property (weak, nonatomic) IBOutlet UILabel *tagLbl2;
@property (weak, nonatomic) IBOutlet UIButton *tagBtn2;

@end

@implementation CommitOrderTopCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}


/**
 没有选择年卡Vip

 @param model model
 */
-(void)configNotVipCell:(id)model {
    
    self.tagLbl1.hidden = YES;
    self.tagBtn1.hidden = YES;
    self.tagLbl2.text = @"价格";
    [self.tagBtn2 bk_whenTapped:^{
        //TODO:价格
    }];
    
    
}


/**
 选择了年卡vip

 @param model model
 */
-(void)configVipCell:(id)model {
    
    self.tagLbl1.hidden = NO;
    self.tagBtn1.hidden = NO;
    self.tagLbl1.text = @"价格";
    [self.tagBtn1 bk_whenTapped:^{
        //TODO:价格
    }];
    self.tagLbl2.text = @"操作";
    [self.tagBtn2 bk_whenTapped:^{
        //TODO:操作
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
