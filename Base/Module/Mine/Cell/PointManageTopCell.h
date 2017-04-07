//
//  PointManageTopCell.h
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PointManageTopCell : UITableViewCell

@property(nonatomic,copy)void (^qianDaoClick)();
@property (weak, nonatomic) IBOutlet UIButton *qiandaoBtn;

+(NSString*)identify;


/**
 configPointManageTopCell

 @param minePoint 个人积分
 @param canSign 是否能签到
 */
-(void)configPointManageTopCell:(id)minePoint canSign:(NSInteger)canSign;

@end
