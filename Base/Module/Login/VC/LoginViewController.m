//
//  LoginViewController.m
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "LoginViewController.h"
#import "UIViewController+Extension.h"
#import "NSString+HYUtilities.h"

@interface LoginViewController ()

@property (weak, nonatomic) IBOutlet UIView* accountView;
@property (weak, nonatomic) IBOutlet UIView* passwordView;
@property (weak, nonatomic) IBOutlet UITextField *accountTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;

@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UIView *eyeView;

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
    
    if (self.schemaArgu[@"phone"]) {
        self.accountTf.text = [self.schemaArgu objectForKey:@"phone"];
    }
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
    self.navigationLineHidden = YES;
    [self addBackgroundImageWithFrame:self.view.bounds];

    for (UIView* view in @[self.accountView,self.passwordView]) {
        UIView *line = [HYTool getLineWithFrame:CGRectZero lineColor:[UIColor whiteColor]];
        [view addSubview:line];
        [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 35, 0, 0) excludingEdge:ALEdgeTop];
        [line autoSetDimension:ALDimensionHeight toSize:0.5];
    }
    
    self.accountTf.keyboardType = UIKeyboardTypeNumberPad;
    self.passwordTf.secureTextEntry = YES;
    
    [HYTool configViewLayer:self.loginBtn size:20];
    [HYTool configViewLayer:self.registBtn withColor:[UIColor whiteColor]];
    [HYTool configViewLayer:self.registBtn size:20];
    
    if (kAccount) {
        self.accountTf.text = kAccount;
    }
//    self.otherLoginView.hidden = YES;
}

- (void)subviewBind {
    
    [self.loginBtn addTarget:self action:@selector(login) forControlEvents:UIControlEventTouchUpInside];
    [self.registBtn addTarget:self action:@selector(regist) forControlEvents:UIControlEventTouchUpInside];
    [self.forgotBtn addTarget:self action:@selector(forgot) forControlEvents:UIControlEventTouchUpInside];
    
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
    if (![self.accountTf.text validateWithValidateType:ValidateTypeForMobile]) {
        [MBProgressHUD hy_showMessage:@"请输入正确的手机号" inView:self.view];
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
            APIHELPER.userInfo = [UserInfoModel yy_modelWithDictionary:responseObject[@"data"]];
            kSaveAccountAndPassword(self.accountTf.text, self.passwordTf.text)
            [self.navigationController popViewControllerAnimated:YES];
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

@end
