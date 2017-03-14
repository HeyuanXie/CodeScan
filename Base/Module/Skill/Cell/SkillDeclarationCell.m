//
//  SkillDeclarationCell.m
//  Base
//
//  Created by admin on 2017/3/14.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SkillDeclarationCell.h"
#import "NSString+Extension.h"

@interface SkillDeclarationCell ()

@property (weak, nonatomic) IBOutlet UITextView *textView;
@end

@implementation SkillDeclarationCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configDeclarationCell:(id)model {
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
    NSString* text = self.textView.text;
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:4.0];
    self.textView.attributedText = [text addAttribute:@[NSParagraphStyleAttributeName,NSFontAttributeName] values:@[style,[UIFont systemFontOfSize:14]] subStrings:@[text,text]];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
