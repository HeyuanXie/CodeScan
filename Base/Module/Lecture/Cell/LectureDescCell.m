//
//  LectureDescCell.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "LectureDescCell.h"

@interface LectureDescCell ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UIButton *unfoldBtn;

@end

@implementation LectureDescCell

+(NSString*)identify {
    return NSStringFromClass([self class]);
}
-(void)configDescCell:(id)model {
    
    self.descLbl.numberOfLines = self.isFold ? 4 : 0;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSMutableAttributedString* mAttrStr = [[NSMutableAttributedString alloc] initWithString:self.descLbl.text];
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4.0];
    [mAttrStr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, mAttrStr.length)];
    self.descLbl.attributedText = mAttrStr;
    self.descLbl.lineBreakMode = NSLineBreakByTruncatingTail;
    
    @weakify(self);
    [self.unfoldBtn bk_whenTapped:^{
        @strongify(self);
        if (self.unfoldBtnClick) {
            self.unfoldBtnClick();
        }
    }];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
