//
//
//  
//
//  Created by lbxia on 15/10/21.
//  Copyright © 2015年 lbxia. All rights reserved.
//

#import "LBXScanViewController.h"
#import "ScanResultContoller.h"
#import "HYAlertView.h"

@interface LBXScanViewController ()<ScanResultDelegate>

@property (nonatomic, strong) ScanResultContoller* resultController;

@end

@implementation LBXScanViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    if ([self respondsToSelector:@selector(setEdgesForExtendedLayout:)]) {
        
        self.edgesForExtendedLayout = UIRectEdgeNone;
    }
    
    self.view.backgroundColor = [UIColor blackColor];
}

- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    
    [self drawScanView];
    
    //不延时，可能会导致界面黑屏并卡住一会
    [self performSelector:@selector(startScan) withObject:nil afterDelay:0.2];
}

//绘制扫描区域
- (void)drawScanView
{
    if (!_qRScanView)
    {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        
        self.qRScanView = [[LBXScanView alloc]initWithFrame:rect style:_style];
        
        [self.view addSubview:_qRScanView];
    }
    [_qRScanView startDeviceReadyingWithText:@"相机启动中"];
}

- (void)reStartDevice
{
    [_zxingObj start];
}

//启动设备
- (void)startScan
{
    UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    videoView.backgroundColor = [UIColor clearColor];
    [self.view insertSubview:videoView atIndex:0];
    __weak __typeof(self) weakSelf = self;
    
    if (!_zxingObj) {
        
        self.zxingObj = [[ZXingWrapper alloc]initWithPreView:videoView block:^(ZXBarcodeFormat barcodeFormat, NSString *str, UIImage *scanImg) {
            
            LBXScanResult *result = [[LBXScanResult alloc]init];
            [weakSelf scanResultWithArray:@[result]];
            
        }];
        
        if (_isOpenInterestRect) {
            
            //设置只识别框内区域
            CGRect cropRect = [LBXScanView getZXingScanRectWithPreView:videoView style:_style];
                                
             [_zxingObj setScanRect:cropRect];
        }               
    }
    [_zxingObj start];
    
    [_qRScanView stopDeviceReadying];
    [_qRScanView startScanAnimation];    
    self.view.backgroundColor = [UIColor clearColor];
}




- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    
    [NSObject cancelPreviousPerformRequestsWithTarget:self];
 
    [self stopScan];
    
    [_qRScanView stopScanAnimation];
}

- (void)stopScan
{
    [_zxingObj stop];
}

#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //经测试，可以同时识别2个二维码，不能同时识别二维码和条形码
//    for (LBXScanResult *result in array) {
//        
//        NSLog(@"scanResult:%@",result.strScanned);
//    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    self.scanImage = scanResult.imgScanned;
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
    // [LBXScanWrapper systemVibrate];
    //声音提醒
    //[LBXScanWrapper systemSound];
    
    [self handleResult:(NSString*)strResult];
}

- (void)popAlertMsgWithScanResult:(NSString*)strResult
{
    if (!strResult) {
        
        strResult = @"识别失败";
    }
    
    __weak __typeof(self) weakSelf = self;
    HYAlertView* alert = [HYAlertView sharedInstance];
    [alert showAlertView:@"扫码内容" message:strResult subBottonTitle:@"知道了" handler:^(AlertViewClickBottonType bottonType) {
        [weakSelf reStartDevice];
    }];
}

//子类继承必须实现的提示
- (void)showError:(NSString*)str
{
    [MBProgressHUD hy_showMessage:str inView:self.view];
}

//MARK: - ScanResultDelegate
- (void)actionSucceedAfterScan {
    
    NSString* message = self.resultController.orderType == 1 ? @"验票成功" : @"兑换成功";
    UIAlertController* alert = [UIAlertController alertControllerWithTitle:nil message:message preferredStyle:UIAlertControllerStyleAlert];
    [alert addAction:[UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        [self hideResultView];
    }]];
    [self presentViewController:alert animated:YES completion:nil];
}

//MARK: - 扫描得到结果
- (void)handleResult:(NSString*)strResult {
    
    [APIHELPER codeScan:strResult type:0 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            [self showResultViewWithData:responseObject[@"data"]];
        }else{
            [MBProgressHUD hy_showMessage:error.userInfo[NSLocalizedDescriptionKey] inView:self.view];
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
    
    [self stopScan];
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
    }];
    
    [self.zxingObj start];
}


@end
