//
//  MessageOrderCell.m
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MessageOrderCell.h"
#import "MessageModel.h"

@interface MessageOrderCell ()

@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

@end

@implementation MessageOrderCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configMessageOrderCell:(id)model {
    MessageModel* message = (MessageModel*)model;
    self.typeLbl.text = message.title;
    self.detailLbl.text = message.content;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
