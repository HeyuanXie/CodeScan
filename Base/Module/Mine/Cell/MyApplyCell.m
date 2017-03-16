//
//  MyApplyCell.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MyApplyCell.h"
#import "NSString+Extension.h"

@interface MyApplyCell ()

@property (weak, nonatomic) IBOutlet UIView *topView;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLblWidth;
@property (weak, nonatomic) IBOutlet UILabel *statuLbl;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *botLbls;

@end

@implementation MyApplyCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configMineApplyCell:(id)model isLecture:(BOOL)isLecture{
    
    NSString* title = @"第一届东莞儿童好声音大赛开幕式";
    CGFloat width = [title sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:CGFLOAT_MAX].width;
    self.titleLblWidth.constant = width + 10;
    self.titleLbl.text = title;
    
    ((UILabel*)self.botLbls.lastObject).hidden = !isLecture;
    
    [self.topView bk_whenTapped:^{
        
    }];
    //TODO:
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [HYTool configViewLayer:self.statuLbl withColor:[UIColor hyRedColor]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
