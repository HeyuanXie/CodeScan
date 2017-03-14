//
//  VideoListCell.h
//  Base
//
//  Created by admin on 2017/3/14.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface VideoListCell : UITableViewCell

+(NSString*)identify;
-(void)configListCell:(id)model;

@end
