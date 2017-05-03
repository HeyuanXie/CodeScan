//
//  MineCommentCell.h
//  Base
//
//  Created by admin on 2017/3/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MineCommentCell : UITableViewCell

@property(nonatomic,copy)void (^imageClick)(NSInteger index);
@property(nonatomic,weak)IBOutlet UIView *botLine;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

+(NSString*)identify;

-(void)configTheaterCell:(id)model;
-(void)configDeriveCell:(id)model;

@end
