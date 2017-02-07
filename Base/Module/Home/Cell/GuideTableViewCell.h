//
//  GuideTableViewCell.h
//  Base
//
//  Created by admin on 2017/2/7.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GuideTableViewCell : UITableViewCell

@property(nonatomic,weak)IBOutlet UIView* view1;
@property(nonatomic,weak)IBOutlet UIView* view2;
@property(nonatomic,weak)IBOutlet UIView* view3;
@property(nonatomic,weak)IBOutlet UIView* view4;
@property(nonatomic,weak)IBOutlet UIView* view5;
@property(nonatomic,weak)IBOutlet UIView* view6;


+(NSString*)identify;

-(void)configCell;

@end
