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

@property(nonatomic,copy)void (^subClick)();
@property(nonatomic,copy)void (^addClick)();



+(NSString*)identify;
-(void)configCommonCell:(id)model count:(NSInteger)count;

@end
