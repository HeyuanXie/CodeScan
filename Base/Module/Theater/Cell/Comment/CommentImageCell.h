//
//  CommentImageCell.h
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentImageCell : UITableViewCell

+(NSString*)identify;

-(void)configTheaterCell:(id)model;
-(void)configLectureCell:(id)model;
-(void)configDeriveCell:(id)model;
-(void)configSkillCell:(id)model;

@end
