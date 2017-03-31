//
//  DeriveListCell.h
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DeriveModel.h"

@interface DeriveListCell : UITableViewCell

@property(nonatomic,copy)void (^itemClick)(DeriveModel* model);       //点击item
@property(nonatomic,copy)void (^exchangeClick)(DeriveModel* model);   //点击兑换按钮

+(NSString*)identify;
-(void)configListCellWithLeft:(DeriveModel*)leftModel right:(DeriveModel*)rightModel;

@end
