//
//  MineCommentCell.h
//  Base
//
//  Created by admin on 2017/3/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCommentCell : UITableViewCell

+(NSString*)identify;

-(void)configTheaterCell:(id)model;
-(void)configDeriveCell:(id)model;

@end
