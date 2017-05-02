//
//  HomeDescCell.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HomeDescCell.h"
#import "NSString+HYUtilities.h"

@interface HomeDescCell ()

@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UIButton *foldBtn;

@end

@implementation HomeDescCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configDescCell:(id)model {
    
    if (model) {
        NSString * htmlString = model[@"card_content"];
        NSAttributedString * attrStr = [[NSAttributedString alloc] initWithData:[htmlString dataUsingEncoding:NSUnicodeStringEncoding] options:@{ NSDocumentTypeDocumentAttribute: NSHTMLTextDocumentType } documentAttributes:nil error:nil];
        self.descLbl.attributedText = attrStr;
        self.descLbl.font = [UIFont systemFontOfSize:14];
    }
    
    [self.foldBtn bk_whenTapped:^{
        if (self.unFoldBtnClick) {
            self.unFoldBtnClick();
        }
    }];
    
    NSString* imgName = self.isFold ? @"三角形_黑色下" : @"三角形_黑色上";
    [self.foldBtn setImage:ImageNamed(imgName) forState:UIControlStateNormal];
    self.descLbl.numberOfLines = self.isFold ? 6 : 0;
    self.descLbl.lineBreakMode = NSLineBreakByTruncatingTail;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
