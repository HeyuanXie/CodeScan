//
//  CommentListCell.h
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBottom;
+(NSString*)identify;
-(void)configListCell:(id)model;

@end
