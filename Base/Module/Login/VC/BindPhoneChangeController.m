//
//  BindPhoneChangeController.m
//  Base
//
//  Created by admin on 2017/3/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BindPhoneChangeController.h"
#import "HYCountDown.h"

typedef enum : NSUInteger {
    TypeBind,
    TypeForget,
} ContentType;

@interface BindPhoneChangeController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *phoneTf;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;

@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *bindBtn;
@property (strong, nonatomic) HYCountDown* countDown;

@property (assign, nonatomic) ContentType contentType;

@end

@implementation BindPhoneChangeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"contentType"]) {
        self.contentType = [[self.schemaArgu objectForKey:@"contentType"] integerValue];
    }
    [self subviewStyle];
    [self subviewBind];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - textField delegate
-(void)textFieldDidChanged:(UITextField*)textField {
    if (![self.phoneTf.text isEmpty] && ![self.codeTf.text isEmpty]) {
        self.bindBtn.backgroundColor = [UIColor hyBarTintColor];
    }else{
        self.bindBtn.backgroundColor = RGB(211, 211, 211, 1.0);
    }
}

#pragma mark - private methods
-(void)subviewStyle {
    
    [HYTool configViewLayer:self.getCodeBtn withColor:[UIColor hySeparatorColor]];
    [HYTool configViewLayer:self.getCodeBtn size:13];
    
    self.phoneTf.keyboardType = UIKeyboardTypeNumberPad;
    self.codeTf.keyboardType = UIKeyboardTypeNumberPad;
    
    if (self.contentType == TypeForget) {
        [self.bindBtn setTitle:@"下一步" forState:UIControlStateNormal];
        self.title = @"找回密码";
    }
}

-(void)subviewBind {
    
    [self.getCodeBtn addTarget:self action:@selector(fetchCode:) forControlEvents:UIControlEventTouchUpInside];
    [self.phoneTf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.codeTf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
}

-(void)fetchCode:(UIButton*)btn {
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
    
    [APIHELPER fetchCode:self.phoneTf.text type:self.contentType==TypeForget ? @"safe" : @"bind" complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        fetchCode(isSuccess,error.userInfo[NSLocalizedDescriptionKey]);
    }];
}

#pragma mark - IBActions
- (IBAction)bind:(id)sender {
    if ([self.phoneTf.text isEmpty]) {
        [self showMessage:@"请输入新的手机号"];
        return;
    }
    if ([self.codeTf.text isEmpty]) {
        [self showMessage:@"请输入验证码"];
        return;
    }
    
    if (self.contentType == TypeForget) {
        //找回密码检验验证码
        [APIHELPER checkCode:self.phoneTf.text code:self.codeTf.text type:@"safe" complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                APPROUTE(([NSString stringWithFormat:@"%@?contentType=1&phone=%@",kChangePasswordController,self.phoneTf.text]));
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    }else{
        //修改绑定手机
        [APIHELPER bindPhone:self.phoneTf.text code:self.codeTf.text complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
            if (isSuccess) {
                [self showMessage:@"修改绑定成功"];
                APIHELPER.userInfo.phone = self.phoneTf.text;
                UIViewController* vc = self.navigationController.viewControllers[2];
                [self.navigationController popToViewController:vc animated:YES];
            }else{
                [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
            }
        }];
    }

}


@end
