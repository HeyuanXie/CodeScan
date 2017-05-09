//
//  ResultTicketCell.h
//  Base
//
//  Created by admin on 2017/5/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTicketCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *seatLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuLBl;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *selectBtnWidth;
@property(nonatomic,copy)void (^selectBtnClick)();


+(NSString*)identify;
-(void)configTicketCell:(id)model;

@end
