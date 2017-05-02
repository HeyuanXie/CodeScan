//
//  PointDescController.m
//  Base
//
//  Created by admin on 2017/3/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "PointDescController.h"

@interface PointDescController ()

@property (weak, nonatomic) IBOutlet UILabel *firstLbl;
@property (weak, nonatomic) IBOutlet UILabel *secondLbl;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *firstLblHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *secondLblHeight;

@end

@implementation PointDescController

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
    
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:2.0];
    
    NSMutableAttributedString* mAttr1 = [[NSMutableAttributedString alloc] initWithString:self.firstLbl.text];
    [mAttr1 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.firstLbl.text.length)];
    self.firstLbl.attributedText = mAttr1;
    
    NSMutableAttributedString* mAttr2 = [[NSMutableAttributedString alloc] initWithString:self.secondLbl.text];
    [mAttr2 addAttribute:NSParagraphStyleAttributeName value:style range:NSMakeRange(0, self.secondLbl.text.length)];
    self.secondLbl.attributedText = mAttr2;

    if (IS_IPHONE_Plus) {
        self.firstLblHeight.constant = 20;
        self.secondLblHeight.constant = 20;
    }
}

@end
