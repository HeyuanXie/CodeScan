//
//  TheaterListCell.h
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheaterListCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIView *backView;
@property(nonatomic,weak)IBOutlet UIImageView *imgV;
@property(nonatomic,weak)IBOutlet UIButton *collectBtn;
@property(nonatomic,weak)IBOutlet UILabel *titleLbl;
@property(nonatomic,weak)IBOutlet UILabel *typeLbl;//类型
@property(nonatomic,weak)IBOutlet UILabel *timeLbl;//时长
@property(nonatomic,weak)IBOutlet UILabel *dateLbl;//上映
@property(nonatomic,weak)IBOutlet UILabel *priceLbl;//票价
@property (weak, nonatomic) IBOutlet UIButton *ticketBtn;

@property(nonatomic,copy)void (^ticketBtnClick)(id model);



+(NSString*)identify;

-(void)configTheaterListCell:(id)model;

@end
