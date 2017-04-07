//
//  CommentListCell.m
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CommentListCell.h"

@interface CommentListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@property (weak, nonatomic) IBOutlet UIView *scoreV;
@property (weak, nonatomic) IBOutlet UILabel *commentLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *botScroll;

@end

@implementation CommentListCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configListCell:(id)model {
    
//    self.nameLbl.text = model[@"user_name"];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model[@"header_img"]] placeholderImage:ImageNamed(@"elephant")];
    self.timeLbl.text = model[@"create_time"];
    self.commentLbl.text = model[@"content"];
    NSArray* imgs = model[@"show_img"];
    for (int i=0; i<imgs.count; i++) {
        UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(8+(106+8)*i, 0, 106, 106)];
        [imgV sd_setImageWithURL:[NSURL URLWithString:imgs[i]] placeholderImage:ImageNamed(@"yazi")];
        [self.botScroll addSubview:imgV];
    }
    self.botScroll.contentSize = CGSizeMake(8+(106+8)*imgs.count, 0);
    
    NSInteger score = [model[@"score"] integerValue];
    for (int i=0; i<score/2; i++) {
        UIButton* btn = (UIButton*)[self.scoreV viewWithTag:1000+i];
        [btn setImage:ImageNamed(@"星星01") forState:UIControlStateNormal];
    }
    for (int i=(int)score/2; i<5; i++) {
        UIButton* btn = (UIButton*)[self.scoreV viewWithTag:1000+i];
        [btn setImage:ImageNamed(@"星星02") forState:UIControlStateNormal];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
