//
//  OrderDetailHeadCell.h
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailHeadCell : UITableViewCell

+(NSString*)identify;

-(void)configTheaterHeadCell:(id)model;
-(void)configLectureHeadCell:(id)model;
-(void)configDeriveHeadCell:(id)model;
-(void)configYearCardHeadCell:(id)model;

@end
