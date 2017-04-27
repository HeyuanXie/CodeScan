//
//  CommitOrderSeatCell.h
//  Base
//
//  Created by admin on 2017/3/27.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FVSeatItem.h"

@interface CommitOrderSeatCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *seatLbl;
@property (weak, nonatomic) IBOutlet UILabel *pirceLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *pirceLblLeading;

@property (weak, nonatomic) IBOutlet UIView *originalPriceView;
@property (weak, nonatomic) IBOutlet UILabel *originalPriceLbl;

@property (weak, nonatomic) IBOutlet UIButton *selelctBtn;

+(NSString*)identify;

-(void)configNotVipCell:(id)model;
-(void)configVipCell:(id)model row:(NSInteger)row cardIndexs:(NSArray*)cardIndexs;

@end
