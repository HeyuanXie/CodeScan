//
//  NewsCell.h
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIView *allView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *allViewHeight;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;

+(NSString*)identify;
-(void)configNewsCell:(id)model;

@end
