//
//  DeriveDetailController.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "DeriveDetailController.h"
#import "APIHelper+Derive.h"

@interface DeriveDetailController ()
@property (weak, nonatomic) IBOutlet UIImageView *botImgV;
@property (weak, nonatomic) IBOutlet UILabel *botLbl;

@property (weak, nonatomic) IBOutlet UIButton *botBtn;

@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botViewHeight;

@property (assign, nonatomic) NSInteger productId;
@property (assign, nonatomic) BOOL isEnough;

@property (strong, nonatomic) NSDictionary* data;

@end

@implementation DeriveDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"id"]) {
        self.productId = [[self.schemaArgu objectForKey:@"id"] integerValue];
    }

    [self webViewInit];
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


#pragma mark - private methods
-(void)webViewInit {
    
}

-(void)fetchData {
    [self showLoadingAnimation];
    [APIHELPER deriveDetail:self.productId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        if (isSuccess) {
            self.data = responseObject[@"data"];
            self.isEnough = self.data[@"is_enough_price"];
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

-(void)subviewBind {
    if (self.isEnough) {
        [self.botBtn addTarget:self action:@selector(exchange) forControlEvents:UIControlEventTouchUpInside];

    }else{
        [self.botBtn addTarget:self action:@selector(gain) forControlEvents:UIControlEventTouchUpInside];
    }
}
-(void)exchange {
    //TODO:兑换
    [self showLoadingAnimation];
    [APIHELPER deriveExchange:self.productId buyNum:1 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        
        if (isSuccess) {
            [ROUTER routeByStoryboardID:[NSString stringWithFormat:@"%@?contentType=1&",kTheaterCommmitOrderSuccessController] withParam:self.data];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}
-(void)gain {
    //TODO:赚积分
}


@end
