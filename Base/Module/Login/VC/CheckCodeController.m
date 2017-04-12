//
//  CheckCodeController.m
//  Base
//
//  Created by admin on 2017/4/7.
//  Copyright © 2017年 XHY. All rights reserved.
//

//修改登陆密码、修改绑定手机的中间验证页面
#import "CheckCodeController.h"
#import "HYCountDown.h"
#import "NSString+HYMobileInsertInterval.h"

@interface CheckCodeController ()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UILabel *phoneLbl;
@property (weak, nonatomic) IBOutlet UITextField *codeTf;
@property (weak, nonatomic) IBOutlet UIButton *getCodeBtn;
@property (weak, nonatomic) IBOutlet UIButton *nextBtn;
@property (strong,nonatomic) HYCountDown* countDown;

@end

@implementation CheckCodeController

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
    if (self.codeTf.text.integerValue/10000 != 0) {
        self.nextBtn.backgroundColor = [UIColor hyBarTintColor];
    }else{
        self.nextBtn.backgroundColor = RGB(211, 211, 211, 1.0);
    }
}

#pragma mark - private methods
-(void)subviewStyle {
    
    [HYTool configViewLayer:self.getCodeBtn withColor:[UIColor hySeparatorColor]];
    [HYTool configViewLayer:self.getCodeBtn size:13];
    
    self.codeTf.keyboardType = UIKeyboardTypeNumberPad;
    self.phoneLbl.text = [NSString stringWithFormat:@"验证码将发送至手机:%@",[APIHELPER.userInfo.phone HTMobileInsertSecurity]];
}

-(void)subviewBind {
    
    [self.getCodeBtn addTarget:self action:@selector(fetchCode:) forControlEvents:UIControlEventTouchUpInside];
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
    
    [APIHELPER fetchCode:APIHELPER.userInfo.phone type:@"safe" complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        fetchCode(isSuccess,error.userInfo[NSLocalizedDescriptionKey]);
    }];
}

- (IBAction)next:(id)sender {
    if ([self.codeTf.text isEmpty]) {
        [self showMessage:@"请输入验证码"];
        return;
    }
    [APIHELPER checkCode:APIHELPER.userInfo.phone code:self.codeTf.text type:@"safe" complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            switch (self.contentType) {
                case TypePassword:
                    APPROUTE(kChangePasswordController);
                    break;
                case TypePhone:
                    APPROUTE(kBindPhoneChangeController);
                    break;
                default:
                    break;
            }
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

@end
