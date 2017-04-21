//
//  RegistViewController.m
//  Base
//
//  Created by admin on 2017/3/2.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "RegistViewController.h"
#import "UIViewController+Extension.h"
#import "HYCountDown.h"

@interface RegistViewController ()

@property (weak, nonatomic) IBOutlet UIView *phoneView;
@property (weak, nonatomic) IBOutlet UIView *codeView;
@property (weak, nonatomic) IBOutlet UIView *passwordView;
@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UITextField *passwordTf;


@property (weak, nonatomic) IBOutlet NSLayoutConstraint *loginViewTop;
@property (weak, nonatomic) IBOutlet UIButton *loginBtn;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *eyeBtn;
@property (weak, nonatomic) IBOutlet UIView * eyeView;

@property (weak, nonatomic) IBOutlet UIView *otherLoginView;
@property (weak, nonatomic) IBOutlet UIView *weixinView;
@property (weak, nonatomic) IBOutlet UIImageView *qqView;
@property (weak, nonatomic) IBOutlet UIImageView *weiboView;

@property (strong, nonatomic) HYCountDown* countDown;

@end

@implementation RegistViewController

- (void)viewDidLoad {
   [super viewDidLoad];
    // Do any additional setup after loading the view.
   [self subviewStyle];
   [self subviewBind];
   
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - IBAction
- (IBAction)regiest:(id)sender {
    if ([self.phoneTf.text isEmpty]) {
        [MBProgressHUD hy_showMessage:@"请输入手机号" inView:self.view];
        return;
    }
    if (![self.phoneTf.text validateWithValidateType:ValidateTypeForMobile]) {
        [MBProgressHUD hy_showMessage:@"请输入正确的手机号" inView:self.view];
        return;
    }
    if ([self.codeTf.text isEmpty]) {
        [MBProgressHUD hy_showMessage:@"请输入验证码" inView:self.view];
        return;
    }
    if ([self.passwordTf.text isEmpty]) {
        [MBProgressHUD hy_showMessage:@"请输入密码" inView:self.view];
        return;
    }
    [self showLoadingAnimation];
    //TODO:注册
    [APIHELPER regist:self.phoneTf.text password:self.passwordTf.text code:self.codeTf.text complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        if (isSuccess) {
           [Global setUserAuth:responseObject[@"data"][@"auth"]];
           APIHELPER.userInfo = [UserInfoModel yy_modelWithDictionary:responseObject[@"data"]];
           APPROUTE(([NSString stringWithFormat:@"%@?phone=%@",kLoginViewController,self.phoneTf.text]));
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}
- (IBAction)login:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - system delegate


#pragma mark - private methods
- (void)subviewStyle {
    
   self.navigationLineHidden = YES;
   [self addBackgroundImageWithFrame:self.view.bounds];
   
    for (UIView* view in @[self.phoneView,self.codeView,self.passwordView]) {
        UIView* line = [HYTool getLineWithFrame:CGRectZero lineColor:[UIColor whiteColor]];
        [view addSubview:line];
        [line autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 35, 0, 0) excludingEdge:ALEdgeTop];
        [line autoSetDimension:ALDimensionHeight toSize:0.5];
    }
    
    self.phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTf.keyboardType = UIKeyboardTypeNumberPad;
    
    self.passwordTf.secureTextEntry = YES;
    self.eyeBtn.enabled = NO;
    
    [HYTool configViewLayer:self.getCodeBtn withColor:[UIColor whiteColor]];
    [HYTool configViewLayer:self.getCodeBtn size:13];
    [HYTool configViewLayer:self.loginBtn withColor:[UIColor whiteColor]];
    [HYTool configViewLayer:self.loginBtn size:20];
    
//    self.otherLoginView.hidden = YES;
    self.loginViewTop.constant = zoom(84);
}

-(void)subviewBind {
    
    [self.eyeView bk_whenTapped:^{
        self.eyeBtn.selected = !self.eyeBtn.selected;
       NSString* image = self.eyeBtn.selected ? @"密码可见" : @"密码不可见";
       [self.eyeBtn setImage:ImageNamed(image) forState:UIControlStateNormal];
        self.passwordTf.secureTextEntry = !self.eyeBtn.selected;
    }];
    
    [self.getCodeBtn addTarget:self action:@selector(fetchCode:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)fetchCode:(UIButton*)btn {
    if ([self.phoneTf.text isEmpty]) {
        [self showMessage:@"请输入手机号"];
        return;
    }
   if (![self.phoneTf.text validateWithValidateType:ValidateTypeForMobile]) {
      [self showMessage:@"请输入正确的手机号"];
      return;
   }
    [self showLoadingAnimation];
    
    @weakify(self);
    void (^fetchCode)(BOOL isSuccess,NSString* msg) = ^(BOOL isSuccess, NSString* msg) {
        @strongify(self);
        if (!isSuccess) {
            [self showMessage:msg];
        }else{
           self.getCodeBtn.enabled = NO;
           @weakify(self);
           self.countDown = [HYCountDown countDownWithWholeSecond:60 WithEachSecondBlock:^(NSInteger currentTime) {
              @strongify(self);
              [self.getCodeBtn setTitle:[NSString stringWithFormat:@"%lds",currentTime] forState:UIControlStateDisabled];
           } WithCompletionHandler:^{
              @strongify(self);
              self.getCodeBtn.enabled = YES;
              [self.getCodeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
           }];
        }
    };
    
    [APIHELPER fetchRegistCode:self.phoneTf.text complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
       [self hideLoadingAnimation];
       fetchCode(isSuccess,error.userInfo[NSLocalizedDescriptionKey]);
    }];
}

@end
