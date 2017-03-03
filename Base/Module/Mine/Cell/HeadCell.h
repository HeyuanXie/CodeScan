//
//  HeadCell.h
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface HeadCell : UITableViewCell

@property(nonatomic,copy)void (^waitUseBlock)();
@property(nonatomic,copy)void (^waitEvaluateBlock)();
@property(nonatomic,copy)void (^afterBlock)();

@property (weak, nonatomic) IBOutlet UIImageView *userHeadImg;
@property (weak, nonatomic) IBOutlet UILabel *userNameLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *userInfoViewTop;

@property (weak, nonatomic) IBOutlet UIView *roundWhiteView;

@property (weak, nonatomic) IBOutlet UILabel *waitUseLbl;
@property (weak, nonatomic) IBOutlet UILabel *waitEvaluateLbl;
@property (weak, nonatomic) IBOutlet UILabel *afterLbl;

+(NSString*)identify;
+(CGFloat)height;

- (void)configHeadCell:(id)model;

@end
