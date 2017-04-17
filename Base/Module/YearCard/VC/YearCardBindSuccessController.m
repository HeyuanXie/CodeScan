//
//  YearCardBindSuccessController.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "YearCardBindSuccessController.h"

@interface YearCardBindSuccessController ()

@property(nonatomic,strong)NSString* deadline;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation YearCardBindSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.schemaArgu objectForKey:@"deadline"]) {
        self.deadline = [self.schemaArgu objectForKey:@"deadline"];
    }
    [self subviewStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions
- (IBAction)leave:(id)sender {
    
    //要先设置tab.selectIndex=0回到首页，再popToRootViewController让order的导航控制器回到rootViewController
    UITabBarController* tab = (UITabBarController*)kApplication.keyWindow.rootViewController;
    tab.selectedIndex = 0;
    [self.navigationController popToRootViewControllerAnimated:YES];
}

-(void)subviewStyle {
    self.timeLbl.text = [NSString stringWithFormat:@"有效期至: %@",self.deadline];
}

@end
