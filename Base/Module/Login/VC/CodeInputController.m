//
//  CodeInputController.m
//  Base
//
//  Created by admin on 2017/5/8.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CodeInputController.h"
#import "ScanResultContoller.h"

@interface CodeInputController ()<ScanResultDelegate>

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *inputTop;
@property (weak, nonatomic) IBOutlet UITextField *codeInput;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;
@property (weak, nonatomic) IBOutlet UIButton *scanBtn;

@property (strong,nonatomic) ScanResultContoller* resultController;

@end

@implementation CodeInputController

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

//MARK: - ScanResultDelegate
- (void)actionSucceedAfterScan {
    NSString* message = self.resultController.orderType == 1 ? @"验票成功" : @"兑换成功";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self hideResultView];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

#pragma mark - private methods 
- (void)subviewStyle {
    
    self.view.backgroundColor = RGB(40, 40, 40, 1.0);
    self.inputTop.constant = 35*kScale_height;
    self.codeInput.clearButtonMode = UITextFieldViewModeWhileEditing;
    
    [HYTool configViewLayer:self.commitBtn];
    [HYTool configViewLayer:self.scanBtn size:21*kScale_height];
}

- (void)subviewBind {
    
    [self.commitBtn addTarget:self action:@selector(commit:) forControlEvents:UIControlEventTouchUpInside];
    [self.scanBtn addTarget:self action:@selector(scan:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)commit:(UIButton*)btn {
    
    //TODO:
    if ([self.codeInput.text isEmpty]) {
        [self showMessage:@"请输入消费码"];
        return;
    }
    if (self.codeInput.text.length != 9) {
        [self showMessage:@"请输入正确的消费码(9位)"];
        return;
    }
    [APIHELPER codeScan:self.codeInput.text type:1 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            [self.codeInput resignFirstResponder];
            [self showResultViewWithData:responseObject[@"data"]];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];

}

- (ScanResultContoller *)resultController {
    if (!_resultController) {
        _resultController = (ScanResultContoller*)VIEWCONTROLLER(kScanResultController);
        _resultController.orderType = 1;
        _resultController.delegate = self;
    }
    return _resultController;
}

- (void)showResultViewWithData:(NSDictionary*)data {
    
    NSInteger orderType = [data[@"order_type"] integerValue];
    NSArray* tickets = orderType==1 ? data[@"detail"] : [NSArray array];
    BOOL haveTicketAvilable = NO;
    for (NSDictionary* dict in tickets) {
        if ([dict[@"status"] integerValue] == 0) {
            haveTicketAvilable = YES;
        }
    }
    self.resultController.haveTicketAvilable = haveTicketAvilable;
    self.resultController.orderType = orderType;
    self.resultController.tickets = tickets;
    self.resultController.data = data;
    
    UIView* backGrayView = [[UIView alloc] initWithFrame:self.view.bounds];
    backGrayView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.2];
    backGrayView.tag = 10000;
    [backGrayView bk_whenTapped:^{
        [self hideResultView];
    }];
    [self.view addSubview:backGrayView];
    
    [self addChildViewController:self.resultController];
    CGFloat height = 0.0;
    if (orderType == 1) {
        if (haveTicketAvilable) {
            height = 122+60+tickets.count*48;
        }else{
            height = 100+60+tickets.count*48;
        }
    }else{
        height = 100+60;
    }
    height = MIN(self.view.bounds.size.height, height);
    self.resultController.view.frame = CGRectMake(0, self.view.bounds.size.height, kScreen_Width, 0);
    [self.view addSubview:self.resultController.view];
    [UIView animateWithDuration:0.3 animations:^{
        self.resultController.view.frame = CGRectMake(0, self.view.bounds.size.height-height, kScreen_Width, height);
    }];
}

- (void)hideResultView {
    
    [UIView animateWithDuration:0.3 animations:^{
        self.resultController.view.frame = CGRectMake(0, self.view.bounds.size.height, kScreen_Width, 0);
    } completion:^(BOOL finished) {
        [self.resultController.view removeFromSuperview];
        [self.resultController removeFromParentViewController];
        if ([self.view viewWithTag:10000]) {
            [[self.view viewWithTag:10000] removeFromSuperview];
        }
        [self.codeInput becomeFirstResponder];
    }];
    
}


- (void)scan:(UIButton*)btn {
    
    [self.navigationController popViewControllerAnimated:YES];
}

@end
