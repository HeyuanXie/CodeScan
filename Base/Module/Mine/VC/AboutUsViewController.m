//
//  AboutUsViewController.m
//  Base
//
//  Created by admin on 2017/4/13.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "AboutUsViewController.h"

@interface AboutUsViewController ()

@property (weak, nonatomic) IBOutlet UIImageView *logoImgV;
@property (weak, nonatomic) IBOutlet UILabel *nameLbl;
@property (weak, nonatomic) IBOutlet UILabel *descLbl;

@end

@implementation AboutUsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self subviewStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
-(void)subviewStyle {
    
    self.logoImgV.image = ImageNamed(@"小飞象logo");
    [HYTool configViewLayer:self.logoImgV size:8];
    
    self.nameLbl.text = [NSString stringWithFormat:@"小飞象王国 %@",APP_VERSION];
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:8.0];
    NSMutableAttributedString* mAttr = [[NSMutableAttributedString alloc] initWithString:self.descLbl.text];
    [mAttr addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.descLbl.text.length)];
    self.descLbl.attributedText = mAttr;

}

@end
