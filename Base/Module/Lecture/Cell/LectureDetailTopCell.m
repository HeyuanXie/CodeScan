//
//  LectureDetailTopCell.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "LectureDetailTopCell.h"

@interface LectureDetailTopCell ()

@property (weak, nonatomic) IBOutlet UIImageView *backImgV;

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *titleLbl;
@property (weak, nonatomic) IBOutlet UILabel *countLbl;
@property (weak, nonatomic) IBOutlet UILabel *addressLbl;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;
@property (weak, nonatomic) IBOutlet UILabel *statuLbl;

@property (weak, nonatomic) IBOutlet UILabel *expertLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;

@end

@implementation LectureDetailTopCell

+(NSString *)identify {
    return NSStringFromClass([self class]);
}

-(void)configTopCell:(id)model {
    //TODO:已报人数红色
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.statuLbl.backgroundColor = [self.statuLbl.backgroundColor colorWithAlphaComponent:0.5];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
