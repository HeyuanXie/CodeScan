//
//  LectureApplyerCell.h
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LectureApplyerCell : UITableViewCell

@property(nonatomic,copy)void (^seeAll)();

+(NSString*)identify;
+(CGFloat)height:(id)model;
-(void)configApplyerCell:(id)model;

@end
