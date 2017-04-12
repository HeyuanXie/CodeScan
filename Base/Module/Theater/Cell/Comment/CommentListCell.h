//
//  CommentListCell.h
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CommentModel.h"

@interface CommentListCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *scrollBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topLineVHeight;
+(NSString*)identify;
-(void)configListCell:(CommentModel*)model type:(NSInteger)type;

@end
