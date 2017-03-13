//
//  TheaterDetailCell.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterDetailCell.h"
#import "UIImageView+HYImageView.h"

@interface TheaterDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIImageView *backImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UILabel *scoreLbl;
@property (weak, nonatomic) IBOutlet UILabel *styleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *dateLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuLbl;

@property (weak, nonatomic) IBOutlet UILabel *descriptionLbl;


@end

@implementation TheaterDetailCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTopCell:(id)model {
    
    [self.unfoldBtn bk_whenTapped:^{
        if (self.unfoldBtnClick) {
            self.unfoldBtnClick();
        }
    }];
    
    NSMutableAttributedString* mAttStr = [[NSMutableAttributedString alloc] initWithString:self.descriptionLbl.text];
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4.0];
    [mAttStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.descriptionLbl.text.length)];
    self.descriptionLbl.attributedText = mAttStr;
    self.descriptionLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    
    self.descriptionLbl.numberOfLines = self.isFold ? 4 : 0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.statuLbl.backgroundColor = [self.statuLbl.backgroundColor colorWithAlphaComponent:0.5];
    [self.backImgV setBlurEffectStyle:UIBlurEffectStyleLight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
