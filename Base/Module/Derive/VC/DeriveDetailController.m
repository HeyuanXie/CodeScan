//
//  DeriveDetailController.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "DeriveDetailController.h"
#import "UIViewController+Extension.h"


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
    }

    [self configNavigation];
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
            self.isFav = self.data[@"is_fav"];
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
    //TODO:兑换
    [self showLoadingAnimation];
    [APIHELPER deriveExchange:self.productId buyNum:1 complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        [self hideLoadingAnimation];
        
        if (isSuccess) {
            [ROUTER routeByStoryboardID:[NSString stringWithFormat:@"%@?contentType=1&",kTheaterCommitOrderSuccessController] withParam:self.data];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}
-(void)gain {
    //TODO:赚积分
}


@end
