//
//  HomeNewsCell.h
//  Base
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeNewsCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLeadConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLeadConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgVWidthConstraint;

+(NSString*)identify;
-(void)configCellWithModel:(id)model;

@end
