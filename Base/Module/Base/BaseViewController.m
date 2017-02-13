//
//  BaseViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD+hyHUD.h"

@interface BaseViewController ()

@end

@implementation BaseViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
//    return UIStatusBarStyleDefault;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor hyViewBackgroundColor];
    self.needLogEvent = YES;
    self.navigationBarHidden = NO;
    //在iOS 7中，苹果引入了一个新的属性，叫做[UIViewController setEdgesForExtendedLayout:]，它的默认值为UIRectEdgeAll。当你的容器是navigation controller时，默认的布局将从navigation bar的顶部开始。这就是为什么所有的UI元素都往上漂移了44pt。
    self.edgesForExtendedLayout = UIRectEdgeNone;
}

-(void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    if (self.needLogEvent) {
        //        [MobClick beginLogPageView:NSStringFromClass([self Class])];
    }
    if (!self.backItemHidden && !self.navigationItem.leftBarButtonItems) {
        UIButton* leftButton = [UIButton buttonWithType:UIButtonTypeCustom];
        leftButton.frame = CGRectMake(0, 0, 44, 32);
        leftButton.imageEdgeInsets = UIEdgeInsetsMake(0, -5, 0, 0);
        leftButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -5);
        leftButton.titleLabel.font = [UIFont systemFontOfSize:14];
        [leftButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [leftButton setTitle:@"返回" forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (self.needLogEvent) {
        //        [MobClick endLogPageView:NSStringFromClass([self class])];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//返回方法
- (void)backAction {
    if (self.navigationController.viewControllers.count > 1) {
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

- (void)showLoadingAnimation {
        [MBProgressHUD hy_showLoadingHUDAddedTo:self.view animated:YES];
}

- (void)hideLoadingAnimation {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
}

- (void)showMessage:(NSString *)message {
        [MBProgressHUD hy_showMessage:message inView:self.view];
}

- (void)showMessage:(NSString *)message complete:(void(^)())complate {
    [MBProgressHUD hy_showMessage:message inView:self.view completionBlock:complate];
}

#pragma mark - 横竖屏

-(BOOL)shouldAutorotate {
    return NO;
}
-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}
-(UIInterfaceOrientation)preferredInterfaceOrientationForPresentation{
    return UIInterfaceOrientationPortrait;
}
@end
