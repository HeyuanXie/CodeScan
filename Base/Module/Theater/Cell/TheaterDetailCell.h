//
//  TheaterDetailCell.h
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheaterDetailCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *unfoldBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unfoldBtnHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botViewHeight;
@property(nonatomic,copy)void (^unfoldBtnClick)();



+(NSString*)identify;
-(void)configTopCell:(id)model;

@end
