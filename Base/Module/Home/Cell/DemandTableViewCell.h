//
//  DemandTableViewCell.h
//  Base
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DemandTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *companyLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;

+(NSString*)identify;

-(void)config:(id)model;

@end
