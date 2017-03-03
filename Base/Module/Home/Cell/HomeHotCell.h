//
//  HomeHotCell.h
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeHotCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UIView) NSArray *hotSubviews;

+(NSString*)identify;

-(void)configHotCell:(id)model;

@end
