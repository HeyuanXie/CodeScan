//
//  ResultBotCell.h
//  Base
//
//  Created by admin on 2017/5/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ResultBotCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UIButton *btn;

+(NSString*)identify;
-(void)configBotCell:(id)model;

@end
