//
//  YearCardOrderCommonCell.h
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YearCardOrderCommonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property(nonatomic,copy)void (^eyeClick)();

+(NSString*)identify;

-(void)configYearCardOrderCommonCell:(id)model;
-(void)configYearCardOrderCommonEyeCell:(id)model;
@end
