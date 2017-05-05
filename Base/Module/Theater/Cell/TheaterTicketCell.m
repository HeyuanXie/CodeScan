//
//  TheaterTicketCell.m
//  Base
//
//  Created by admin on 2017/3/8.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterTicketCell.h"
#import "NSString+Extension.h"
#import "TheaterSessionModel.h"

@interface TheaterTicketCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *theatreLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *ticketBtn;


@end

@implementation TheaterTicketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [HYTool configViewLayerFrame:self.ticketBtn WithColor:[UIColor hyBlueTextColor]];
    [HYTool configViewLayer:self.ticketBtn];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTicketCell:(id)model {
    
    TheaterSessionModel* session = (TheaterSessionModel*)model;
    NSString* time = [[HYTool dateStringWithString:session.playTime inputFormat:nil outputFormat:@"yyyy-MM-dd HH:mm"] stringByAppendingString:[NSString stringWithFormat:@" (%@)",[HYTool weekStirngWithDate:[HYTool dateWithString:session.playTime format:nil]]]];
    self.timeLbl.text = time;
    self.theatreLbl.text = session.theaterName;
    self.addressLbl.text = session.address;
    self.priceLbl.text = [NSString stringWithFormat:@"¥%@",session.price];
    
    NSMutableAttributedString* mAttrStr = [self.priceLbl.text addAttribute:@[NSFontAttributeName] values:@[[UIFont systemFontOfSize:12]] subStrings:@[@"¥"]];
    self.priceLbl.attributedText = mAttrStr;
    
    [self.ticketBtn bk_whenTapped:^{
        if (self.ticketBtnClick) {
            self.ticketBtnClick();
        }
    }];
}

@end
