//
//  FunctionCell.h
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FunctionCell : UITableViewCell

@property(nonatomic,copy)void (^detailBlock)();
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *backView;

+(NSString*)identify;
-(void)configFunctionCell:(id)model;

@end
