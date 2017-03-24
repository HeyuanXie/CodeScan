//
//  SearchGuideCell.h
//  Base
//
//  Created by admin on 2017/3/23.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchGuideCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *closeView;
@property (weak, nonatomic) IBOutlet UIButton *closeAllBtn;

+(NSString*)identify;
-(void)configGuideHistoryCell:(id)model;
-(void)configGuideHeadCell;
-(void)configGuideClearAllCell;

@end
