//
//  CommentScoreCell.m
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CommentScoreCell.h"

@interface CommentScoreCell ()

@property (weak, nonatomic) IBOutlet UIView *scoreView;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *scoreBtns;

@end

@implementation CommentScoreCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    for (UIButton* btn in self.scoreBtns) {
        
        UIImageView* imgV = [[UIImageView alloc] initWithFrame:btn.bounds];
        [btn addSubview:imgV];
        imgV.image = ImageNamed(@"星星01");
        imgV.tag = 1000;
    }
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configScoreCell:(int)score {

    int i=0;
    for (UIButton* btn in self.scoreBtns) {
        [btn bk_whenTapped:^{
            if (self.scoreBtnClick) {
                self.scoreBtnClick(i);
            }
        }];
        i++;
    }
    
    for (int i=0; i<score; i++) {
        UIButton* btn = self.scoreBtns[i];
        UIImageView* imgV = [btn viewWithTag:1000];
        imgV.image = ImageNamed(@"星星01");
    }
    for (int i=score; i<5; i++) {
        UIButton* btn = self.scoreBtns[i];
        UIImageView* imgV = [btn viewWithTag:1000];
        imgV.image = ImageNamed(@"星星02");
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
