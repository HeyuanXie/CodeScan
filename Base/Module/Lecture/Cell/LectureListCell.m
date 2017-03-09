//
//  LectureListCell.m
//  Base
//
//  Created by admin on 2017/3/8.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "LectureListCell.h"
#import "NSString+Extension.h"

@interface LectureListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;

@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;
@property (weak, nonatomic) IBOutlet UIButton *applyBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLblTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *titleLblWidth;

@end

@implementation LectureListCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configListCell:(id)model {
    
    if (0) {
        self.statuLbl.hidden = YES;
    }
    
    NSString* max = [NSString stringWithFormat:@"人数: %d人 ",100];
    NSString* still = [NSString stringWithFormat:@"(剩余%d人)",79];
    NSString* count = [max stringByAppendingString:still];
    self.countLbl.attributedText = [count attributedStringWithString:still andWithColor:RGB(240, 66, 103, 1.0)];
    
    self.titleLblTop.constant = zoom(60);
    CGSize size = [self.titleLbl.text sizeWithFont:[UIFont systemFontOfSize:17] maxWidth:kScreen_Width-24];
    self.titleLblWidth.constant = size.width+10;
    
    [self.applyBtn bk_whenTapped:^{
        if (self.applyBtnClick) {
            self.applyBtnClick(model);
        }
    }];
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    [HYTool configViewLayerRound:self.imgV];
    
    [HYTool configViewLayer:self.statuLbl withColor:RGB(240, 66, 103, 1.0)];
    [HYTool configViewLayer:self.statuLbl size:10];
    
    [HYTool configViewLayer:self.applyBtn withColor:RGB(106, 176, 243, 1.0)];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
