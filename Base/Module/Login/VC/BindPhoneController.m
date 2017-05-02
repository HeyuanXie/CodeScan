//
//  BindPhoneController.m
//  Base
//
//  Created by admin on 2017/3/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BindPhoneController.h"
#import "HYCountDown.h"

@interface BindPhoneController ()<UITextFieldDelegate>

@property (strong, nonatomic) HYCountDown* countDown;

@property (weak, nonatomic) IBOutlet UITextField *firstTf;
@property (weak, nonatomic) IBOutlet UITextField *secondTf;
@property (weak, nonatomic) IBOutlet UIButton *codeBtn;
@property (weak, nonatomic) IBOutlet UIButton *submitBtn;

@end

@implementation BindPhoneController

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


#pragma mark - private methods
-(void)subviewStyle {
    [HYTool configViewLayer:self.codeBtn withColor:[UIColor lightGrayColor]];
    [HYTool configViewLayer:self.codeBtn size:13];
}

-(void)subviewBind {
    
    [self.firstTf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.secondTf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.codeBtn addTarget:self action:@selector(fetchCode:) forControlEvents:UIControlEventTouchUpInside];
}

-(void)fetchCode:(UIButton*)btn {
    @weakify(self);
    void (^fetchCode)(BOOL isSuccess,NSString* msg) = ^(BOOL isSuccess, NSString* msg) {
        @strongify(self);
        if (!isSuccess) {
            [self showMessage:msg];
        }else{
            self.codeBtn.enabled = NO;
            @weakify(self);
            self.countDown = [HYCountDown countDownWithWholeSecond:60 WithEachSecondBlock:^(NSInteger currentTime) {
                @strongify(self);
                [self.codeBtn setTitle:[NSString stringWithFormat:@"%lds",currentTime] forState:UIControlStateDisabled];
            } WithCompletionHandler:^{
                @strongify(self);
                self.codeBtn.enabled = YES;
                [self.codeBtn setTitle:@"获取验证码" forState:UIControlStateNormal];
            }];
        }
    };
    
    [APIHELPER fetchResetPWCode:APIHELPER.userInfo.phone complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        fetchCode(isSuccess,error.userInfo[NSLocalizedDescriptionKey]);
    }];
}


-(void)textFieldDidChanged:(UITextField*)textField {
    if (![self.firstTf.text isEmpty] && ![self.secondTf.text isEmpty]) {
        self.submitBtn.backgroundColor = [UIColor hyBarTintColor];
    }else{
        self.submitBtn.backgroundColor = RGB(211, 211, 211, 1.0);
    }
}

- (IBAction)submit:(id)sender {
    if ([self.firstTf.text isEmpty]) {
        [self showMessage:@"请输入手机号"];
        return;
    }
    if ([self.secondTf.text isEmpty]) {
        [self showMessage:@"请输入验证码"];
        return;
    }
    //绑定手机
    [APIHELPER bindPhone:self.firstTf.text code:self.secondTf.text complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            [self showMessage:@"绑定成功"];
            APIHELPER.userInfo.phone = self.firstTf.text;
            [self.navigationController popViewControllerAnimated:YES];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}


@end
