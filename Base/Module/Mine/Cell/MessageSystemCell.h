//
//  MessageSystemCell.h
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageSystemCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UIButton *foldBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *foldBtnHeight;

@property(nonatomic,copy)void (^foldBtnClick)();


+(NSString*)identify;
-(void)configMessageCell:(id)model isFold:(BOOL)isFold;

/*
 detailLbl文字内容高度小于49则没有展开btn
 */
@end
