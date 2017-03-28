//
//  TheaterSeatView.m
//  Base
//
//  Created by admin on 2017/3/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterSeatView.h"
#import "FVSeatItem.h"

@interface TheaterSeatView ()

@property (weak, nonatomic) IBOutlet UILabel *seatLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *deleteBtn;


@end

@implementation TheaterSeatView

-(void)configSeatView:(id)model {
    
    FVSeatItem* item = (FVSeatItem*)model;
    self.seatLbl.text = item.seatName;
    self.priceLbl.text = [NSString stringWithFormat:@"%d",item.price];
    [self.deleteBtn bk_whenTapped:^{
        if (self.deleteClick) {
            self.deleteClick();
        }
    }];
}

@end
