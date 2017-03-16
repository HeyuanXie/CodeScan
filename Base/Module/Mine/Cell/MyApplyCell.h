//
//  MyApplyCell.h
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MyApplyCell : UITableViewCell

+(NSString*)identify;
-(void)configMineApplyCell:(id)model isLecture:(BOOL)isLecture;

@end
