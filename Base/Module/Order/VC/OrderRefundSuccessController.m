//
//  OrderRefundSuccessController.m
//  Base
//
//  Created by admin on 2017/3/28.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "OrderRefundSuccessController.h"

@interface OrderRefundSuccessController ()

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@end

@implementation OrderRefundSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];

    [self subviewStyle];
    [self subviewBind];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - private methods
-(void)subviewStyle {
    
    [HYTool configViewLayer:self.continueBtn withColor:[UIColor colorWithString:@"6bb3f6"]];
}

-(void)subviewBind {
    
    [self.continueBtn addTarget:self action:@selector(stroll) forControlEvents:UIControlEventTouchUpInside];
}

-(void) stroll {
    //要先设置tab.selectIndex=0回到首页，再popToRootViewController让order的导航控制器回到rootViewController
    UITabBarController* tab = (UITabBarController*)kApplication.keyWindow.rootViewController;
    tab.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

@end
