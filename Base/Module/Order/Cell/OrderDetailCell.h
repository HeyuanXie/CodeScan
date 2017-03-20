//
//  OrderDetailCell.h
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderDetailCell : UITableViewCell

+(NSString*)identify;
-(void)configDetailCell:(id)model;

@end
