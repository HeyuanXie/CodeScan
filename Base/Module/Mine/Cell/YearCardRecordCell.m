//
//  YearCardRecordCell.m
//  Base
//
//  Created by admin on 2017/4/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "YearCardRecordCell.h"

@interface YearCardRecordCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation YearCardRecordCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configYearCardRecordCell:(id)model {
    
    if (!model) {
        return;
    }
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model[@"picurl"]] placeholderImage:nil];
    self.titleLbl.text = model[@"play_name"];
    self.detailLbl.text = model[@"sub_title"];
    self.timeLbl.text = [HYTool dateStringWithString:model[@"play_time"] inputFormat:nil outputFormat:@"yyyy-MM-dd HH:mm"];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
