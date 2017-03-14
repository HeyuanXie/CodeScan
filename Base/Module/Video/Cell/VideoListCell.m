//
//  VideoListCell.m
//  Base
//
//  Created by admin on 2017/3/14.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "VideoListCell.h"
#import "NSString+Extension.h"

@interface VideoListCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headImgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIView *durationView;
@property (weak, nonatomic) IBOutlet UILabel *durationLbl;
@property (weak, nonatomic) IBOutlet UILabel *seeCountLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentCountLbl;

@end

@implementation VideoListCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configListCell:(id)model {
    
    NSString* commentCount = [@" " stringByAppendingString:@"124"];
    NSMutableAttributedString* mAttr = [[commentCount attributeStringWithAttachment:CGRectMake(0, 0, 14, 14) fontSize:12 textColor:[UIColor hyGrayTextColor] index:0 imageName:@"cart"] mutableCopy];
    [mAttr addAttribute:NSFontAttributeName value:[UIFont systemFontOfSize:12] range:NSMakeRange(0, commentCount.length)];
    self.commentCountLbl.attributedText = mAttr;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.durationView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.5];
    [HYTool configViewLayerRound:self.headImgV];
    [HYTool configViewLayer:self.commentCountLbl withColor:[UIColor hySeparatorColor]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
