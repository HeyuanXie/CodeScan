//
//  DeriveDetailController.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "DeriveDetailController.h"
#import "UIViewController+Extension.h"
#import "HYAlertView.h"

@interface DeriveDetailController ()
@property (weak, nonatomic) IBOutlet UIImageView *botImgV;
@property (weak, nonatomic) IBOutlet UILabel *botLbl;

@property (weak, nonatomic) IBOutlet UIButton *botBtn;

@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botViewHeight;

@property (assign, nonatomic) NSInteger productId;
@property (assign, nonatomic) BOOL isEnough;
@property (assign, nonatomic) BOOL isFav;

@property (strong, nonatomic) NSDictionary* data;

@end

@implementation DeriveDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"isFav"]) {
        self.isFav = [[self.schemaArgu objectForKey:@"isFav"] boolValue];
    }
    if (self.schemaArgu[@"id"]) {
        self.productId = [[self.schemaArgu objectForKey:@"id"] integerValue];
        self.url = [NSString stringWithFormat:@"http://xfx.zhimadi.cn/goods?goods_id=%ld",self.productId];
        if ([Global userAuth]) {
            self.url = [self.url stringByAppendingString:[NSString stringWithFormat:@"&uid=%@",APIHELPER.userInfo.userID]];
        }
    }
//    if (self.schemaArgu[@"sourceUrl"]) {
//        self.url = [self.schemaArgu objectForKey:@"sourceUrl"];
//    }
    
    [self loadWebView];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - override methods
-(void)webViewInit {
    [super webViewInit];
    
    [self.webView autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(-44, 0, -90, 0)];
    [self.view sendSubviewToBack:self.webView];
}

#pragma mark - private methods
-(void)fetchData {
    [self showLoadingAnimation];
    [APIHELPER deriveDetail:self.productId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        if (isSuccess) {
            self.data = responseObject[@"data"];
            self.isEnough = [self.data[@"is_enough_price"] boolValue];
            self.isFav = [self.data[@"is_fav"] boolValue];
            [self configNavigation];
            [self subviewStyle];
            [self subviewBind];
        }
    }];
}

-(void)subviewStyle {
    if (self.isEnough) {
        self.botImgV.hidden = YES;
        self.botLbl.hidden = YES;
        self.botViewHeight.constant = 60;
        [self.botBtn setTitle:@"立即兑换" forState:UIControlStateNormal];
        return;
    }else{
        self.botImgV.hidden = NO;
        self.botLbl.hidden = NO;
        self.botViewHeight.constant = 90;
        [self.botBtn setTitle:@"去赚更多积分" forState:UIControlStateNormal];
    }
}

-(void)configNavigation {
    NSArray* images = self.isFav ? @[@"collect02",@"share"] : @[@"collect01",@"share"];
    @weakify(self);
    [self addDoubleNavigationItemsWithImages:images firstBlock:^{
        @strongify(self);
        if (!self.isFav) {
            //TODO:收藏
            [APIHELPER collect:self.productId type:4 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    [self showMessage:@"收藏成功"];
                    self.isFav = !self.isFav;
                    [self configNavigation];
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
        }else{
            //TODO:取消收藏
            [APIHELPER cancelCollect:self.productId type:4 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                if (isSuccess) {
                    [self showMessage:@"取消收藏成功"];
                    self.isFav = !self.isFav;
                    [self configNavigation];
                }else{
                    [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                }
            }];
        }
    } secondBlock:^{
        //TODO:分享
        
    }];
}

-(void)subviewBind {
    if (self.isEnough) {
        [self.botBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];

    }else{
        [self.botBtn addTarget:self action:@selector(gain) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)exchange {
    
    HYAlertView* alert = [HYAlertView sharedInstance];
    [alert setSubBottonBackgroundColor:[UIColor hyRedColor]];
    [alert setSubBottonTitleColor:[UIColor whiteColor]];
    [alert setCancelButtonBorderColor:[UIColor hyBarTintColor]];
    [alert setCancelButtonTitleColor:[UIColor hyBarTintColor]];
    [alert setCancelButtonBackgroundColor:[UIColor whiteColor]];
    [alert setBtnCornerRadius:5];
    [alert showAlertViewWithMessage:[NSString stringWithFormat:@"是否用%ld积分兑换该商品?",[self.data[@"shop_price"] integerValue]] subBottonTitle:@"确定" cancelButtonTitle:@"取消" handler:^(AlertViewClickBottonType bottonType) {
        switch (bottonType) {
            case AlertViewClickBottonTypeSubBotton: {
                //兑换
                [self showLoadingAnimation];
                [APIHELPER deriveExchange:[self.data[@"goods_id"] integerValue] buyNum:1 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
                    [self hideLoadingAnimation];
                    if (isSuccess) {
                        NSDictionary* param = responseObject[@"data"];
                        //剧场下单成功和衍生品兑换成功公用一个VC
                        [ROUTER routeByStoryboardID:[NSString stringWithFormat:@"%@?contentType=1&order_sn=%@&",kTheaterCommitOrderSuccessController,responseObject[@"data"][@"order_sn"]] withParam:param];
                    }else{
                        [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
                    }
                }];
                break;
            }
            default:{
                break;
            }
        }
    }];
}
-(void)gain {
    //TODO:赚积分
}


@end
