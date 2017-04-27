//
//  MessageSystemCell.m
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MessageSystemCell.h"
#import "NSString+Extension.h"
#import "MessageModel.h"

@implementation MessageSystemCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configMessageCell:(id)model isFold:(BOOL)isFold {
    
    [self.foldBtn bk_whenTapped:^{
        if (self.foldBtnClick) {
            self.foldBtnClick();
        }
    }];
    
    MessageModel* message = (MessageModel*)model;
    self.timeLbl.text = [HYTool dateStringWithString:message.updateTime inputFormat:nil outputFormat:@"yyyy-MM-dd HH:mm"];
    self.detailLbl.numberOfLines = isFold ? 2 : 0;
    self.detailLbl.text = message.content;
    NSString* title = isFold ? @"展开" : @"收起";
    NSString* image = isFold ? @"蓝色箭头_下" : @"蓝色箭头_上";
    [self.foldBtn setTitle:title forState:UIControlStateNormal];
    [self.foldBtn setImage:ImageNamed(image) forState:UIControlStateNormal];
    CGFloat textHeight = [message.content sizeWithFont:[UIFont systemFontOfSize:15] maxWidth:kScreen_Width-24].height;
    self.foldBtnHeight.constant = textHeight < 49 ? 12 : 46;
    self.foldBtn.hidden = textHeight < 49 ? YES : NO;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
