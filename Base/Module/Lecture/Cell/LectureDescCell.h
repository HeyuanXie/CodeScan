//
//  LectureDescCell.h
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LectureDescCell : UITableViewCell

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *unfoldBtnHeight;
@property(assign, nonatomic) BOOL isFold;
@property(nonatomic,copy)void (^unfoldBtnClick)();


+(NSString*)identify;
-(void)configDescCell:(id)model;


@end
