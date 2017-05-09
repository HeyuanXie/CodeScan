//
//  ResultTopCell.h
//  Base
//
//  Created by admin on 2017/5/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultTopCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuLbl;
@property (weak, nonatomic) IBOutlet UIButton *allBtn;
@property(nonatomic,copy)void (^allBtnClick)();


+(NSString*)identify;

-(void)configTheaterCell:(id)model;
-(void)configDeriveCell:(id)model;

@end
