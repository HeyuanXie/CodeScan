//
//  ApplyTitleCell.h
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyTitleCell : UITableViewCell

+(NSString*)identify;


/**
 专家讲座报名TitleCell

 @param model model
 */
-(void)configTitleCell:(id)model;


/**
 才艺报名TitleCell

 @param model model
 */
-(void)configSkillApplyTitleCell:(id)model;

@end
