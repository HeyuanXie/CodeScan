//
//  HomeNewsCell.m
//  Base
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HomeNewsCell.h"
#import "ZMDArticle.h"

@implementation HomeNewsCell

+(NSString*)identify {
    return NSStringFromClass([HomeNewsCell class]);
}

-(void)configCellWithModel:(id)model {
    ZMDArticle* news = (ZMDArticle*)model;
    self.titleLbl.text = news.title;
    self.timeLbl.text = news.publishDate;
    if (![news.thumb isEqualToString:@""]) {
        //有图片
        [self.imgV sd_setImageWithURL:[NSURL URLWithString:news.thumb] placeholderImage:nil completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
            self.timeLeadConstraint.constant = 10;
            self.titleLeadConstraint.constant = 10;
            self.imgVWidthConstraint.constant = 100;
        }];
    }else{
        self.imgVWidthConstraint.constant = 0;
        self.titleLeadConstraint.constant = 0;
        self.timeLeadConstraint.constant = 0;
    }
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
