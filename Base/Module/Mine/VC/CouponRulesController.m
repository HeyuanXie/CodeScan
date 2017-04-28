//
//  CouponRulesController.m
//  Base
//
//  Created by admin on 2017/4/27.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CouponRulesController.h"

@interface CouponRulesController ()

@property (weak, nonatomic) IBOutlet UILabel *firstBigLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstBigLblHeight;
@property (weak, nonatomic) IBOutlet UILabel *secondBigLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondBigLblHeight;
@property (weak, nonatomic) IBOutlet UILabel *botLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botLblTop;

@end

@implementation CouponRulesController

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
- (void)subviewStyle {
    
    self.view.backgroundColor = [UIColor whiteColor];
    self.botLblTop.constant = kScale_height*30;
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:2.0];
    
    NSMutableAttributedString* mAttr1 = [[NSMutableAttributedString alloc] initWithString:self.botLbl.text];
    [mAttr1 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.botLbl.text.length)];
    self.botLbl.attributedText = mAttr1;
    
    NSMutableAttributedString* mAttr2 = [[NSMutableAttributedString alloc] initWithString:self.firstBigLbl.text];
    [mAttr2 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.firstBigLbl.text.length)];
    self.firstBigLbl.attributedText = mAttr2;
    
    NSMutableAttributedString* mAttr3 = [[NSMutableAttributedString alloc] initWithString:self.secondBigLbl.text];
    [mAttr3 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.secondBigLbl.text.length)];
    self.secondBigLbl.attributedText = mAttr3;
    
    if (IS_IPHONE_6) {
        self.firstBigLblHeight.constant = 20;
    }
    if (IS_IPHONE_Plus) {
        self.firstBigLblHeight.constant = 20;
        self.secondBigLblHeight.constant = 20;
    }
}

@end
