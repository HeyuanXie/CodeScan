//
//  ThemeCell.h
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThemeCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuLbl;

+(NSString*)identify;
+(CGFloat)height;
-(void)configThemeCell:(id)model;

@end
