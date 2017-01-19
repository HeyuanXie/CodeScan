//
//  TestViewController.m
//  Base
//
//  Created by admin on 2017/1/18.
//  Copyright © 2017年 XHY. All rights reserved.
//



#import "TestViewController.h"
#import "UIImage+HYImages.h"
#import "UIImageView+HYWebImage.h"
#import "Base-Swift.h"

@interface TestViewController ()

@end

@implementation TestViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self subviewInit];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(void)subviewInit {
    UITextField* field = [HYTool getTextFieldWithFrame:CGRectMake(20, 40, kScreen_Width-40, 20) placeHolder:@"输入点东西吧" fontSize:14 textColor:nil];
    [HYTool configViewLayerFrame:field WithColor:[UIColor hyRedColor]];
    [self.view addSubview:field];
    
    UILabel* label = [HYTool getLabelWithFrame:CGRectZero text:@"HYTool--getLabel" fontSize:14 textColor:nil textAlignment:NSTextAlignmentCenter];
    label.backgroundColor = [UIColor hyRedColor];
    [HYTool configViewLayer:label];
    [self.view addSubview:label];
    [label autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:field withOffset:10];
    [label autoSetDimensionsToSize:CGSizeMake(kScreen_Width, 20)];
    [label autoAlignAxis:ALAxisVertical toSameAxisOfView:field];
    
    UIImageView* imgV = [[UIImageView alloc] init];
    [self.view addSubview:imgV];
    [imgV autoAlignAxisToSuperviewAxis:ALAxisVertical];
    [imgV autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:label withOffset:10];
    [imgV autoSetDimensionsToSize:CGSizeMake(100, 100)];
    [imgV layoutIfNeeded];

    [imgV hy_setImageWithURL:[NSURL URLWithString:@"http://pic6.huitu.com/res/20130116/84481_20130116142820494200_1.jpg"] placeholderImage:nil animated:YES];
    
    
    UIButton* btn = [HYTool getButtonWithFrame:CGRectZero title:@"ceshi" titleSize:16 titleColorForNormal:[UIColor whiteColor] titleColorForSelect:[UIColor blueColor] backgroundColor:[UIColor hyRedColor] blockForClick:nil];
    btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [btn removeFromSuperview];
        [HYTool configViewLayerRound:imgV];
        UIImageView* imgV2 = [[UIImageView alloc] init];
        [self.view addSubview:imgV2];
        [imgV2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:imgV withOffset:10];
        [imgV2 autoSetDimensionsToSize:imgV.frame.size];
        [imgV2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:imgV];
        imgV2.image = [UIImage screenShotOnView:imgV];
        imgV2.image = [UIImage screenShot];
        return [RACSignal empty];
    }];
    
    [self.view addSubview:btn];
    [btn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(15, 15, 15, 15) excludingEdge:ALEdgeTop];
    [btn autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:imgV withOffset:10];
    
}


-(void)viewDidLayoutSubviews {
    
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
