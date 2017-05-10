//
//  CodeScanController.m
//  Base
//
//  Created by admin on 2017/5/8.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CodeScanController.h"
#import "CodeInputController.h"
#import "ScanResultContoller.h"
#import "LBXScanView.h"
#import "LBXScanViewStyle.h"
#import "LBXScanNative.h"
#import "ZXingWrapper.h"
#import "HYAlertView.h"

@interface CodeScanController ()<ScanResultDelegate>

@property (strong,nonatomic) ZXingWrapper* zxingObj;
@property (strong,nonatomic) LBXScanView* qRScanView;
@property (strong,nonatomic) LBXScanViewStyle* style;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UIButton *inputBtn;

@property (strong,nonatomic) ScanResultContoller* resultController;

@end

@implementation CodeScanController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self captureInit];
    [self subviewStyle];
    [self subviewBind];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];

//    [self startScan];
    [self.zxingObj start];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:YES];
    
    [self stopScan];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -实现类继承该方法，作出对应处理

- (void)scanResultWithArray:(NSArray<LBXScanResult*>*)array
{
    if (!array ||  array.count < 1)
    {
        [self popAlertMsgWithScanResult:nil];
        return;
    }
    
    LBXScanResult *scanResult = array[0];
    
    NSString*strResult = scanResult.strScanned;
    
    
    if (!strResult) {
        
        [self popAlertMsgWithScanResult:nil];
        
        return;
    }
    
    //震动提醒
     //[LBXScanWrapper systemVibrate];
    //声音提醒
//    [LBXScanWrapper systemSound];
    
    
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

- (void)reStartDevice {
    
    [self.zxingObj start];
}


#pragma mark - private methods
- (void)captureInit {
    
    //设置扫码区域参数
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 2;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = YES;
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    style.colorAngle = [UIColor colorWithRed:0./255 green:200./255. blue:20./255. alpha:1.0];
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"qrcode_Scan_weixin_Line"];
    style.animationImage = imgLine;
    
    self.style = [[LBXScanViewStyle alloc] init];
    _style.centerUpOffset = self.view.frame.size.height/2-163*kScale_height-(kScreen_Width-zoom(265))/2;
    _style.notRecoginitonArea = RGB(40, 40, 40, 1.0);
    _style.isNeedShowRetangle = NO;
    _style.photoframeAngleH = 12;
    _style.photoframeAngleW = 12;
    _style.photoframeLineW = 2;
    _style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    _style.colorAngle = [UIColor whiteColor];
    UIImage* image = [UIImage imageNamed:@"qrcode_Scan_weixin_Line"];
    _style.animationImage = image;
    //绘制扫描区域
    if (!_qRScanView)
    {
        CGRect rect = self.view.frame;
        rect.origin = CGPointMake(0, 0);
        self.qRScanView = [[LBXScanView alloc]initWithFrame:rect style:style];
        [self.view addSubview:_qRScanView];
    }
    [_qRScanView startDeviceReadyingWithText:@"相机启动中"];
    
    [self startScan];
}

- (void)startScan {
    
    [_qRScanView stopDeviceReadying];
    UIView *videoView = [[UIView alloc]initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame))];
    videoView.backgroundColor = RGB(40, 40, 40, 1.0); //[UIColor clearColor];
    [self.view insertSubview:videoView atIndex:0];
    __weak __typeof(self) weakSelf = self;
    
    if (!_zxingObj) {
        self.zxingObj = [[ZXingWrapper alloc]initWithPreView:videoView block:^(ZXBarcodeFormat barcodeFormat, NSString *str, UIImage *scanImg) {
            
            LBXScanResult *result = [[LBXScanResult alloc]init];
            result.strScanned = str;
            result.imgScanned = scanImg;
            result.strBarCodeType = AVMetadataObjectTypeQRCode;
            
            [weakSelf scanResultWithArray:@[result]];
            
        }];
    }
    
    LBXScanViewStyle *style = [[LBXScanViewStyle alloc]init];
    style.centerUpOffset = 44;
    style.photoframeAngleStyle = LBXScanViewPhotoframeAngleStyle_Inner;
    style.photoframeLineW = 3;
    style.photoframeAngleW = 18;
    style.photoframeAngleH = 18;
    style.isNeedShowRetangle = NO;
    
    style.anmiationStyle = LBXScanViewAnimationStyle_LineMove;
    
    //qq里面的线条图片
    UIImage *imgLine = [UIImage imageNamed:@"qrcode_Scan_weixin_Line"];
    style.animationImage = imgLine;
    CGRect cropRect = [LBXScanView getZXingScanRectWithPreView:videoView style:style];
    [_zxingObj setScanRect:cropRect];
}

- (void)stopScan {
    
    [self.zxingObj stop];
}

- (void)subviewStyle {
    
    [self.view bringSubviewToFront:self.label];
    [self.view bringSubviewToFront:self.inputBtn];
    
    [HYTool configViewLayer:self.inputBtn size:21.0*kScreen_Height/667];
}

- (void)subviewBind {
    
    [self.inputBtn addTarget:self action:@selector(input:) forControlEvents:UIControlEventTouchUpInside];
}

- (void)input:(UIButton*)btn {
    
    CodeInputController* vc = (CodeInputController*)VIEWCONTROLLER(kCodeInputController);
    [self.navigationController pushViewController:vc animated:YES];
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
