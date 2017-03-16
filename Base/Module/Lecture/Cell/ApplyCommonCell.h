//
//  ApplyCommonCell.h
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ApplyCommonCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UITextField *inputTf;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;

@property (weak, nonatomic) IBOutlet UIView *countView;
@property (weak, nonatomic) IBOutlet UILabel *subLbl;
@property (weak, nonatomic) IBOutlet UILabel *addLbl;
@property (weak, nonatomic) IBOutlet UILabel *numLbl;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLblWidth;

@property(nonatomic,copy)void (^subClick)();
@property(nonatomic,copy)void (^addClick)();



+(NSString*)identify;


/**
 专家讲座CommonCell

 @param model 数据源model
 @param count 票数count
 */
-(void)configCommonCell:(id)model count:(NSInteger)count;

-(void)configSkillApplyCommonCell:(id)model;

@end
