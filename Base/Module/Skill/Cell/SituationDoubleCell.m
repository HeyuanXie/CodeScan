//
//  SituationDoubleCell.m
//  Base
//
//  Created by admin on 2017/3/13.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SituationDoubleCell.h"

@interface SituationDoubleCell ()

@property (weak, nonatomic) IBOutlet UIView *leftView;
@property (weak, nonatomic) IBOutlet UIView *centerView;
@property (weak, nonatomic) IBOutlet UIView *rightView;


@end

@implementation SituationDoubleCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configDoubleCellWithLeftModel:(id)leftModel rightModel:(id)rightModel {
    [self configLeftView:leftModel];
    [self configRightView:rightModel];
}


-(void)configLeftView:(id)model {
    
    ((UIImageView*)[self.leftView viewWithTag:1000]).image = ImageNamed(@"yazi");
    ((UILabel*)[self.leftView viewWithTag:1001]).text = @"妮妮芭比";
    ((UIImageView*)[self.leftView viewWithTag:1002]).image = ImageNamed(@"baidi");
    ((UILabel*)[self.leftView viewWithTag:1003]).text = @"1号 大傻";
    ((UILabel*)[self.leftView viewWithTag:1004]).text = @"排名:  1";
    ((UILabel*)[self.leftView viewWithTag:1005]).text = @"80票";
    [((UIButton*)[self.leftView viewWithTag:1006]) bk_whenTapped:^{
        if (self.supportClick) {
            self.supportClick(model);
        }
    }];
    
    [self.leftView bk_whenTapped:^{
        if (self.itemClick) {
            self.itemClick(model);
        }
    }];
}
-(void)configRightView:(id)model {
    if (model == nil) {
        self.rightView.hidden = YES;
    }
    ((UIImageView*)[self.rightView viewWithTag:1000]).image = ImageNamed(@"yazi");
    ((UILabel*)[self.rightView viewWithTag:1001]).text = @"妮妮芭比";
    ((UIImageView*)[self.rightView viewWithTag:1002]).image = ImageNamed(@"baidi");
    ((UILabel*)[self.rightView viewWithTag:1003]).text = @"1号 大傻";
    ((UILabel*)[self.rightView viewWithTag:1004]).text = @"排名:  1";
    ((UILabel*)[self.rightView viewWithTag:1005]).text = @"80票";
    [((UIButton*)[self.rightView viewWithTag:1006]) bk_whenTapped:^{
        if (self.supportClick) {
            self.supportClick(model);
        }
    }];
    
    [self.rightView bk_whenTapped:^{
        if (self.itemClick) {
            self.itemClick(model);
        }
    }];
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    self.centerView.backgroundColor = [UIColor hyViewBackgroundColor];
    
    for (UIView* view in @[self.leftView,self.rightView]) {
        UIImageView* imgV = [view viewWithTag:1000];
        [HYTool configViewLayer:imgV size:36*kScreen_Width/(2*375)];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
