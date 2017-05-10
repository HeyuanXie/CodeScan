//
//  LoginViewController.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "LoginViewController.h"
#import "CodeScanController.h"
#import "UIViewController+Extension.h"
#import "NSString+HYUtilities.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIView* accountView;
@property (weak, nonatomic) IBOutlet UIView* passwordView;
@property (weak, nonatomic) IBOutlet UITextField *accountTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;

@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UIView *eyeView;

@property (weak, nonatomic) IBOutlet UIButton *loginBtn;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationLineHidden = YES;
    self.backItemHidden = YES;
    [self subviewStyle];
    [self subviewBind];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (void)subviewStyle {
    
    self.title = @"登陆";
    [self.navigationController.navigationBar setBackgroundImage:ImageNamed(@"gradualBackground") forBarMetrics:UIBarMetricsDefault];
    [self addBackgroundImageWithFrame:self.view.bounds];

    for (UIView* view in @[self.accountView,self.passwordView]) {
        UIView *line = [HYTool getLineWithFrame:CGRectZero lineColor:[UIColor whiteColor]];
        [view addSubview:line];
        [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 35, 0, 0) excludingEdge:ALEdgeTop];
        [line autoSetDimension:ALDimensionHeight toSize:0.5];
    }
    
    self.passwordTf.secureTextEntry = YES;
    
    [HYTool configViewLayer:self.loginBtn size:20];
    
    if (kAccount) {
        self.accountTf.text = kAccount;
    }
    if (kPassword) {
        self.passwordTf.text = kPassword;
    }
}

- (void)subviewBind {
    
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    
    [self.eyeView bk_whenTapped:^{
        self.eyeBtn.selected = !self.eyeBtn.selected;
        NSString* image = self.eyeBtn.selected ? @"密码可见" : @"密码不可见";
        [self.eyeBtn setImage:ImageNamed(image) forState:UIControlStateNormal];
        self.passwordTf.secureTextEntry = !self.eyeBtn.selected;
    }];
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
    
    [APIHELPER login:self.accountTf.text password:self.passwordTf.text complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [MBProgressHUD hideHUDForView:self.view animated:YES];
        if (isSuccess) {
            
            [Global setUserAuth:responseObject[@"data"][@"auth"]];
            kSaveAccountAndPassword(self.accountTf.text, self.passwordTf.text)
            CodeScanController* vc = (CodeScanController*)VIEWCONTROLLER(kCodeScanController);
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [MBProgressHUD hy_showMessage:error.userInfo[NSLocalizedDescriptionKey] inView:self.view];
        }
    }];

}

@end
