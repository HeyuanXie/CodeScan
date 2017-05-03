//
//  TheaterDetailCell.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterDetailCell.h"
#import "UIImageView+HYImageView.h"
#import "TheaterModel.h"

@interface TheaterDetailCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIImageView *backImgV;
@property (weak, nonatomic) IBOutlet UIButton *playBtn;
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
    
    TheaterModel* theater = (TheaterModel*)model;
    [self.unfoldBtn bk_whenTapped:^{
        if (self.unfoldBtnClick) {
            self.unfoldBtnClick();
        }
    }];
    [self.playBtn bk_whenTapped:^{
        if (self.playBtnClick) {
            self.playBtnClick();
        }
    }];
    
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:theater.picurl] placeholderImage:ImageNamed(@"elephant")];
    [self.backImgV sd_setImageWithURL:[NSURL URLWithString:theater.picurl] placeholderImage:ImageNamed(@"elephant")];
    self.titleLbl.text = theater.playName;
    self.timeLbl.text = [NSString stringWithFormat:@"时长: %@分钟",theater.pctime];
    self.dateLbl.text = [NSString stringWithFormat:@"上映: %@",theater.sydate];
    
    self.descriptionLbl.text = theater.desc;
    NSMutableAttributedString* mAttStr = [[NSMutableAttributedString alloc] initWithString:self.descriptionLbl.text];
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4.0];
    [mAttStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.descriptionLbl.text.length)];
    self.descriptionLbl.attributedText = mAttStr;
    self.descriptionLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    self.descriptionLbl.numberOfLines = self.isFold ? 4 : 0;
    
    NSInteger score = theater.score.intValue;
    self.scoreLbl.text = [NSString stringWithFormat:@"%ld分",score];
    for (int i=0; i<score/2; i++) {
        UIImageView* imgV = (UIImageView*)[self.scoreView viewWithTag:100+i];
        imgV.image = ImageNamed(@"星星01");
   }
    for (int i=(int)score/2; i<5; i++) {
        UIImageView* imgV = (UIImageView*)[self.scoreView viewWithTag:100+i];
        imgV.image = ImageNamed(@"星星02");
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.statuLbl.backgroundColor = [self.statuLbl.backgroundColor colorWithAlphaComponent:0.5];
    self.backImgV.bounds = CGRectMake(0, 0, kScreen_Width, 263);
    [self.backImgV setBlurEffectStyle:UIBlurEffectStyleLight];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
