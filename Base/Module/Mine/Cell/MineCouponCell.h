//
//  MineCouponCell.h
//  Base
//
//  Created by admin on 2017/3/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

@interface MineCouponCell : UITableViewCell

+(NSString*)identify;
-(void)configCouponCell:(CouponModel*)model;

@end
