//
//  MineCommentCell.m
//  Base
//
//  Created by admin on 2017/3/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineCommentCell.h"
#import "NSString+Extension.h"

@interface MineCommentCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentLbl;

@property (weak, nonatomic) IBOutlet UIView *theaterView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *theaterViewBot;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;

@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;

@end

@implementation MineCommentCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [HYTool configViewLayer:self.imgV size:3];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTheaterCell:(id)model {
    
    NSInteger score = [model[@"score"] integerValue];
    for (int i=0; i<score; i++) {
        UIImageView* imgV = (UIImageView*)[self.scoreView viewWithTag:1000+i];
        imgV.image = ImageNamed(@"星星01");
    }
    for (int i=(int)score; i<5; i++) {
        UIImageView* imgV = (UIImageView*)[self.scoreView viewWithTag:1000+i];
        imgV.image = ImageNamed(@"星星02");
    }
    
    self.commentLbl.text = model[@"content"];
    self.timeLbl.text = model[@"create_time"];
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model[@"picurl"]] placeholderImage:ImageNamed(@"elephant")];
    self.titleLbl.text = [[model[@"play_name"] stringByReplacingOccurrencesOfString:@"《" withString:@""] stringByReplacingOccurrencesOfString:@"》" withString:@""];
    self.typeLbl.text = [NSString stringWithFormat:@"%@ / %@分钟",model[@"sub_title"],model[@"pctime"]];
    
    
    NSArray* images = model[@"show_img"];
    if (images.count==0) {
        self.theaterViewBot.constant = 12;
        self.scrollView.hidden = YES;
    }else{
        self.theaterViewBot.constant = 128;
        self.scrollView.hidden = NO;
        for (int i=0; i<images.count; i++) {
            UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(8+(104+8)*i, 0, 104, 104)];
            [imgV sd_setImageWithURL:[NSURL URLWithString:images[i]] placeholderImage:ImageNamed(@"yazi")];
            [self.scrollView addSubview:imgV];
        }
        self.scrollView.contentSize = CGSizeMake(8+(104+8)*images.count, 0);
    }
}

-(void)configDeriveCell:(id)model {
    
    NSInteger score = [model[@"comment_score"] integerValue];
    for (int i=0; i<score; i++) {
        UIImageView* imgV = (UIImageView*)[self.scoreView viewWithTag:1000+i];
        imgV.image = ImageNamed(@"星星01");
    }
    for (int i=(int)score; i<5; i++) {
        UIImageView* imgV = (UIImageView*)[self.scoreView viewWithTag:1000+i];
        imgV.image = ImageNamed(@"星星02");
    }
    
    self.timeLbl.text = model[@"create_time"];
    self.commentLbl.text = model[@"content"];
    
    [self.imgV sd_setImageWithURL:[NSURL URLWithString:model[@"thumb_img"]] placeholderImage:ImageNamed(@"yazi")];
    self.titleLbl.text = model[@"goods_name"];
    NSString* text = [NSString stringWithFormat:@"%ld积分",[model[@"exchange_total_price"] integerValue]];
    NSAttributedString* attStr = [text addAttribute:@[NSForegroundColorAttributeName] values:@[[UIColor hyRedColor]] subStrings:@[[NSString stringWithFormat:@"%ld",[model[@"exchange_total_price"] integerValue]]]];
    self.typeLbl.attributedText = attStr;
    
    NSArray* images = model[@"show_img"];
    if (images.count==0) {
        self.theaterViewBot.constant = 12;
        self.scrollView.hidden = YES;
    }else{
        self.theaterViewBot.constant = 128;
        self.scrollView.hidden = NO;
        for (int i=0; i<images.count; i++) {
            UIImageView* imgV = [[UIImageView alloc] initWithFrame:CGRectMake(8+(104+8)*i, 0, 104, 104)];
            [imgV sd_setImageWithURL:[NSURL URLWithString:images[i]] placeholderImage:ImageNamed(@"yazi")];
            [self.scrollView addSubview:imgV];
        }
        self.scrollView.contentSize = CGSizeMake(8+(104+8)*images.count, 0);
    }
}

@end
