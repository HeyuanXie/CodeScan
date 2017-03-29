//
//  BindPhoneController.m
//  Base
//
//  Created by admin on 2017/3/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BindPhoneController.h"

@interface BindPhoneController ()<UITextFieldDelegate>
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
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private methods
-(void)subviewStyle {
    [HYTool configViewLayer:self.codeBtn withColor:[UIColor lightGrayColor]];
    [HYTool configViewLayer:self.codeBtn size:13];
    
    [self.firstTf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];
    [self.secondTf addTarget:self action:@selector(textFieldDidChanged:) forControlEvents:UIControlEventEditingChanged];

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
    //TODO:绑定
}


@end
