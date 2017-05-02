//
//  CommentImageCell.m
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CommentImageCell.h"
#import "NSString+Extension.h"

@interface CommentImageCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;

@end

@implementation CommentImageCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

//configCell
-(void)configTheaterCell:(id)model {
    
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model[@"picurl"]] placeholderImage:ImageNamed(@"elephant")];
    self.titleLbl.text = [[model[@"play_name"] stringByReplacingOccurrencesOfString:@"《" withString:@""] stringByReplacingOccurrencesOfString:@"》" withString:@""];
    self.typeLbl.text = [NSString stringWithFormat:@"%@ / %@分钟",model[@"sub_title"],model[@"pctime"]];
}

-(void)configLectureCell:(id)model {
    
}

-(void)configDeriveCell:(id)model {
    
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model[@"thumb_img"]] placeholderImage:ImageNamed(@"elephant")];
    self.titleLbl.text = model[@"goods_name"];
    
    NSString* text = [NSString stringWithFormat:@"%ld积分",[model[@"exchange_total_price"] integerValue]];
    NSAttributedString* attStr = [text addAttribute:@[NSForegroundColorAttributeName] values:@[[UIColor hyRedColor]] subStrings:@[[NSString stringWithFormat:@"%ld",[model[@"exchange_total_price"] integerValue]]]];
    self.typeLbl.attributedText = attStr;
}

-(void)configSkillCell:(id)model {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
