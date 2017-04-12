//
//  CommentScoreCell.h
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentScoreCell : UITableViewCell

@property(nonatomic,copy)void (^scoreBtnClick)(int index);

+(NSString*)identify;
-(void)configScoreCell:(int)score;

@end
