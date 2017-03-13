//
//  SituationDoubleCell.h
//  Base
//
//  Created by admin on 2017/3/13.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SituationDoubleCell : UITableViewCell

@property(nonatomic,copy)void (^itemClick)(id model);       //点击item
@property(nonatomic,copy)void (^supportClick)(id model);   //点击支持他按钮

+(NSString*)identify;
-(void)configDoubleCellWithLeftModel:(id)leftModel rightModel:(id)rightModel;

@end
