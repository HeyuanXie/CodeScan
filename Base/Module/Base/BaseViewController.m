//
//  BaseViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseViewController.h"
#import "MBProgressHUD+hyHUD.h"
#import "LoginViewController.h"
#import "RegistViewController.h"
#import "HYAlertView.h"

@interface BaseViewController ()

@property(nonatomic,strong) UIView* navBackView;
@property(nonatomic,strong) UIView* navLine;

@end

@implementation BaseViewController

-(UIStatusBarStyle)preferredStatusBarStyle{
    return UIStatusBarStyleLightContent;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor hyViewBackgroundColor];
    self.needLogEvent = YES;
    self.navigationBarHidden = NO;
    self.navigationBarTransparent = NO;
    self.navigationLineHidden = NO;
    self.navigationBarBlue = NO;
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
        [leftButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        [leftButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        [leftButton setImage:[UIImage imageNamed:@"back"] forState:UIControlStateNormal];
        if ([self isKindOfClass:[LoginViewController class]] || [self isKindOfClass:[RegistViewController class]]) {
            [leftButton setImage:ImageNamed(@"登陆页关闭") forState:UIControlStateNormal];
        }
        self.navigationItem.leftBarButtonItems = @[[[UIBarButtonItem alloc] initWithCustomView:leftButton]];
    }
    if (self.navigationBarTransparent) {
        [self hideBackView:self.navigationController.navigationBar];
    }
    if (self.navigationLineHidden) {
        self.navLine.hidden = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:YES];
    if (self.needLogEvent) {
        //        [MobClick endLogPageView:NSStringFromClass([self class])];
    }
    if (self.navigationBarTransparent == YES) {
        [self showBackView:self.navigationController.navigationBar];
    }
    if (self.navigationLineHidden) {
        self.navLine.hidden = NO;
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - navLine
-(UIView *)navLine {
    if (self.navigationController) {
        UIView *backgroundView = [self.navigationController.navigationBar subviews].firstObject;
        _navLine = backgroundView.subviews.lastObject;
        return _navLine;
    }else{
        return nil;
    }
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


#pragma mark - 设置导航栏透明
- (void)hideBackView:(UIView *) superView{
    NSString* backString = SYSTEM_VERSION_FLOAT >= 10.0 ? @"_UIBarBackground" : @"_UINavigationBarBackground";
    if ([superView isKindOfClass:NSClassFromString(backString)]) {
        for (UIView* view in superView.subviews) {
            //影藏分割线
            if ([view isKindOfClass:[UIImageView class]]) {
                self.navLine = view;
                self.navLine.hidden = YES;
            }
        }
        self.navBackView = superView;
        self.navBackView.alpha = 0;
    }else if ([superView isKindOfClass:NSClassFromString(@"_UIBackdropView")]) {
        superView.hidden = YES;
    }
    for (UIView* view in superView.subviews) {
        [self hideBackView:view];
    }
}

- (void)showBackView:(UIView*)superView {
    NSString* backString = SYSTEM_VERSION_FLOAT >= 10.0 ? @"_UIBarBackground" : @"_UINavigationBarBackground";
    if ([superView isKindOfClass:NSClassFromString(backString)]) {
        for (UIView* view in superView.subviews) {
            //显示分割线
            if ([view isKindOfClass:[UIImageView class]]) {
                self.navLine = view;
                self.navLine.hidden = NO;
            }
        }
        self.navBackView = superView;
        self.navBackView.alpha = 1.0;
    }else if ([superView isKindOfClass:NSClassFromString(@"_UIBackdropView")]) {
        superView.hidden = NO;
    }
    for (UIView* view in superView.subviews) {
        [self showBackView:view];
    }
}

-(void)checkUserLogined {
    
    if ([Global userAuth]==nil) {
        HYAlertView* alert = [HYAlertView sharedInstance];
        [alert setSubBottonBackgroundColor:[UIColor whiteColor]];
        [alert setSubBottonTitleColor:[UIColor hyRedColor]];
        [alert setSubBottonBorderColor:[UIColor hyRedColor]];
        [alert setCancelButtonBackgroundColor:[UIColor hyRedColor]];
        [alert setCancelButtonBorderColor:[UIColor whiteColor]];
        [alert setCancelButtonTitleColor:[UIColor whiteColor]];
        [alert showAlertView:@"未登录!" message:@"是否立即登录?" subBottonTitle:@"取消" cancelButtonTitle:@"确定" handler:^(AlertViewClickBottonType bottonType) {
            switch (bottonType) {
                case AlertViewClickBottonTypeSubBotton:
                    break;
                default:
                    APPROUTE(kLoginViewController);
                    break;
            }
        }];
        return;
    }
}


@end
