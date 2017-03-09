//
//  LectureListCell.h
//  Base
//
//  Created by admin on 2017/3/8.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LectureListCell : UITableViewCell

+(NSString*)identify;
-(void)configListCell:(id)model;

@property(nonatomic,copy)void (^applyBtnClick)();

@end
