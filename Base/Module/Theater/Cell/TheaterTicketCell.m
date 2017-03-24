//
//  TheaterTicketCell.m
//  Base
//
//  Created by admin on 2017/3/8.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterTicketCell.h"
#import "NSString+Extension.h"

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
    
    NSMutableAttributedString* mAttrStr = [self.priceLbl.text addAttribute:@[NSFontAttributeName,NSFontAttributeName,NSForegroundColorAttributeName] values:@[[UIFont systemFontOfSize:12],[UIFont systemFontOfSize:13],[UIColor hyGrayTextColor]] subStrings:@[@"¥",@"起",@"起"]];

    self.priceLbl.attributedText = mAttrStr;
    
    for (NSNumber *num in @[@(0),@(1)]) {
        UIView* ticketView = LOADNIB(@"TheaterUseView", 1);
        [HYTool configViewLayerFrame:ticketView WithColor:[UIColor hySeparatorColor]];
        [ticketView bk_whenTapped:^{
            //TODO:跳到选座,传递场次数据参数
            APPROUTE(kTheaterSeatPreviewController);
        }];
        //TODO:configTicketView
        [self.ticketScroll addSubview:ticketView];
        [ticketView autoSetDimensionsToSize:CGSizeMake(80, 70)];
        [ticketView autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:10+90*num.integerValue];
        [ticketView autoAlignAxisToSuperviewAxis:ALAxisHorizontal];
    }
}

@end
