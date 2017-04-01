//
//  OrderTopCell.h
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIImageView *rightImgV;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

+(NSString*)identify;
-(void)configTopCell:(NSDictionary*)model;


@end
