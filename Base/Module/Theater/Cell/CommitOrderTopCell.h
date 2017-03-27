//
//  CommitOrderTopCell.h
//  Base
//
//  Created by admin on 2017/3/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommitOrderTopCell : UITableViewCell

+(NSString*)identify;

-(void)configNotVipCell:(id)model;
-(void)configVipCell:(id)model;

@end
