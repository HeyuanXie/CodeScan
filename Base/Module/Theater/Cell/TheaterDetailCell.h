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
@property (nonatomic,copy)void (^unfoldBtnClick)();
@property (nonatomic,assign)BOOL isFold;



+(NSString*)identify;
-(void)configTopCell:(id)model;

@end
