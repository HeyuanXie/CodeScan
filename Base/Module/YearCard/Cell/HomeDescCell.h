//
//  HomeDescCell.h
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HomeDescCell : UITableViewCell

@property(nonatomic,copy)void (^unFoldBtnClick)();
@property(nonatomic,assign)BOOL isFold;


+(NSString*)identify;
-(void)configDescCell:(id)model;

@end
