//
//  OrderCodeCell.h
//  Base
//
//  Created by admin on 2017/3/20.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderCodeCell : UITableViewCell

+(NSString*)identify;
-(void)configCodeCell:(id)model;

@end
