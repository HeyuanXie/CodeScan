//
//  OrderListCell.h
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListCell : UITableViewCell

+(NSString*)identify;
-(void)configTheaterCell:(id)model;
-(void)configDeriveCell:(id)model;
-(void)configYearCardCell:(id)model;

@end
