//
//  DeriveListCell.h
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DeriveListCell : UITableViewCell

@property(nonatomic,copy)void (^itemClick)(id model);       //点击item
@property(nonatomic,copy)void (^exchangeClick)(id model);   //点击兑换按钮

+(NSString*)identify;
-(void)configListCellWithLeft:(id)leftModel right:(id)rightModel;

@end
