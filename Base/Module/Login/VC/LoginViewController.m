//
//  LoginViewController.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "LoginViewController.h"
#import "APIHelper+User.h"
#import "UIViewController+Extension.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIView* accountView;
@property (weak, nonatomic) IBOutlet UIView* passwordView;
@property (weak, nonatomic) IBOutlet UITextField *accountTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;

@property (weak, nonatomic) IBOutlet UIButton *forgotBtn;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *registBtn;

@property (weak, nonatomic) IBOutlet UIView *otherLoginView;
@property (weak, nonatomic) IBOutlet UIView *weixinLoginView;
@property (weak, nonatomic) IBOutlet UIView *qqLoginView;
@property (weak, nonatomic) IBOutlet UIView *weiboLoginView;



@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self subviewStyle];
    [self subviewBind];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//- (void)viewWillLayoutSubviews {
//    self.view.frame = CGRectMake(0, 0, kScreen_Width, kScreen_Height);
//}

- (void)subviewStyle {
    self.title = @"登陆";
    self.navigationLineHidden = YES;
    [self addBackgroundImageWithFrame:self.view.bounds];

    for (UIView* view in @[self.accountView,self.passwordView]) {
        UIView *line = [HYTool getLineWithFrame:CGRectZero lineColor:[UIColor whiteColor]];
        [view addSubview:line];
        [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 35, 0, 0) excludingEdge:ALEdgeTop];
        [line autoSetDimension:ALDimensionHeight toSize:0.5];
    }
    
    [HYTool configViewLayer:self.loginBtn size:20];
    [HYTool configViewLayer:self.registBtn withColor:[UIColor whiteColor]];
    [HYTool configViewLayer:self.registBtn size:20];
    
    self.otherLoginView.hidden = YES;
}

- (void)subviewBind {
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.registBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [self.forgotBtn addTarget:self action:@selector(forgot) forControlEvents:UIControlEventTouchUpInside];
}


- (void)login{
    if ([self.accountTf.text isEmpty]) {
        [MBProgressHUD hy_showMessage:@"请输入手机号" inView:self.view];
        return;
    }
    if ([self.passwordTf.text isEmpty]) {
        [MBProgressHUD hy_showMessage:@"请输入密码" inView:self.view];
        return;
    }
    [MBProgressHUD hy_showLoadingHUDAddedTo:self.view animated:YES];
    [APIHELPER loginAccount:self.accountTf.text password:self.passwordTf.text complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            [Global setUserAuth:responseObject[@"data"][@"auth"]];
            APIHELPER.userInfo = [UserInfoModel yy_modelWithDictionary:responseObject[@"data"][@"user"]];
            [self dismissViewControllerAnimated:YES completion:nil];

        }else{
            [MBProgressHUD hy_showMessage:error.userInfo[NSLocalizedDescriptionKey] inView:self.view];
        }
    }];
}

- (void)regist{
    APPROUTE(kRegistViewController);
}

- (void)forgot{
    
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
