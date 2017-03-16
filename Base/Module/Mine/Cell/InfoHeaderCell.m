//
//  InfoHeaderCell.m
//  Template
//
//  Created by hitao on 16/10/4.
//  Copyright © 2016年 hitao. All rights reserved.
//

#import "InfoHeaderCell.h"
#import "UIImageView+HYWebImage.h"

@interface InfoHeaderCell()
@property (weak, nonatomic) IBOutlet UIImageView *headerImageView;

@end

@implementation InfoHeaderCell

+ (CGFloat)height{
    return 100.0;
}

+ (NSString *)identify{
    return NSStringFromClass([InfoHeaderCell class]);
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.headerImageView.layer.cornerRadius = 33.5;
    self.headerImageView.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setHeaderImage:(UIImage *)image{
    self.headerImageView.image = image;
}

- (void)setHeaderUrlString:(NSString *)url{
    [self.headerImageView hy_setImageWithURL:[NSURL URLWithString:url] placeholderImage:ImageNamed(@"noone")];
}

@end
