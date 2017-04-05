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

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet UILabel *noneLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *ticketScroll;

@end

@implementation TheaterTicketCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
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
    self.titleLbl.text = session.theatreName;
    self.addressLbl.text = session.address;
    self.priceLbl.text = session.price;
    
    NSMutableAttributedString* mAttrStr = [self.priceLbl.text addAttribute:@[NSFontAttributeName,NSFontAttributeName,NSForegroundColorAttributeName] values:@[[UIFont systemFontOfSize:12],[UIFont systemFontOfSize:13],[UIColor hyGrayTextColor]] subStrings:@[@"¥",@"起",@"起"]];

    self.priceLbl.attributedText = mAttrStr;
    
    for (int i=0; i<session.children.count; i++) {
        UIView* ticketView = LOADNIB(@"TheaterUseView", 1);
        
        TheaterModel* theater = session.children[i];
        UILabel* timeLbl = (UILabel*)[ticketView viewWithTag:1000];
        UILabel* language = (UILabel*)[ticketView viewWithTag:1001];
        UILabel* priceLbl = (UILabel*)[ticketView viewWithTag:1002];
        timeLbl.text = theater.playTime;
        language.text = theater.language;
        priceLbl.text = [NSString stringWithFormat:@"¥ %@",theater.pricel];

        [HYTool configViewLayerFrame:ticketView WithColor:[UIColor hySeparatorColor]];
        [ticketView bk_whenTapped:^{
            //TODO:跳到选座,传递场次数据参数
            APPROUTE(kTheaterSeatPreviewController);
        }];
        //TODO:configTicketView
        [self.ticketScroll addSubview:ticketView];
        [ticketView autoSetDimensionsToSize:CGSizeMake(80, 70)];
        [ticketView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10+90*i];
        [ticketView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
}

@end
