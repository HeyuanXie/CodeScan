//
//  NewsCell.m
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "NewsCell.h"
#import "ArticleModel.h"
#import "NSDate+HYFormat.h"

@interface NewsCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *detailLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (weak, nonatomic) IBOutlet UIButton *supportBtn;
@property (weak, nonatomic) IBOutlet UIButton *commentBtn;

@end

@implementation NewsCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    for (UIButton* btn in @[self.supportBtn,self.commentBtn]) {
        [HYTool configViewLayer:btn withColor:RGB(191, 191, 191, 1.0)];
        [HYTool configViewLayer:btn size:10];
    }
    [HYTool configViewLayer:self.imgV];
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configNewsCell:(id)model {
    ArticleModel* article = (ArticleModel*)model;
    
    if (article.title) {
        self.titleLbl.text = article.title;
    }
    self.timeLbl.text = [NSDate dateStringWithString:article.addtime inputFormat:nil outputFormat:@"MM-dd HH-mm"];
    if (![article.img isEmpty]) {
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:article.img] placeholderImage:nil];
    }
    
    [self.supportBtn setTitle:[article.light stringValue] forState:UIControlStateNormal];
    [self.commentBtn setTitle:[article.commentNum stringValue] forState:UIControlStateNormal];
    [self.supportBtn bk_whenTapped:^{
        //TODO:点赞
        
    }];
    [self.commentBtn bk_whenTapped:^{
        //TODO:评论
        
    }];
    
    if (article.summary) {
        self.detailLbl.text = article.summary;
    }
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:3.0];
    NSMutableAttributedString* mAttr = [[NSMutableAttributedString alloc] initWithString:self.detailLbl.text];
    [mAttr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.detailLbl.text.length)];
    self.detailLbl.attributedText = mAttr;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

@end
