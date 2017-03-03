//
//  HomeVideoCell.h
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeVideoView.h"

@interface HomeVideoCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(HomeVideoView) NSArray *subViews;

+(NSString*)identify;
-(void)configVideoCell:(id)model;

@end
