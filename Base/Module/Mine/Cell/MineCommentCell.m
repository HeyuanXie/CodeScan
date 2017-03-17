//
//  MineCommentCell.m
//  Base
//
//  Created by admin on 2017/3/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "MineCommentCell.h"

@interface MineCommentCell ()

@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *commentLbl;

@property (weak, nonatomic) IBOutlet UIView *theaterView;
@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *typeLbl;


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

-(void)configMineCommentCell:(id)model {
    
}

@end
