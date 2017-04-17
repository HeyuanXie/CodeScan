//
//  SelectCouponCell.h
//  Base
//
//  Created by admin on 2017/3/27.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CouponModel.h"

@interface SelectCouponCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *selectImgV;

+(NSString*)identify;
-(void)configCouponCell:(id)model;
-(void)configYearCardCell:(id)model;

@end
