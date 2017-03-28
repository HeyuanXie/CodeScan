//
//  DeriveDetailController.m
//  Base
//
//  Created by admin on 2017/3/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "DeriveDetailController.h"

@interface DeriveDetailController ()
@property (weak, nonatomic) IBOutlet UIImageView *botImgV;
@property (weak, nonatomic) IBOutlet UILabel *botLbl;

@property (weak, nonatomic) IBOutlet UIButton *botBtn;

@property (weak, nonatomic) IBOutlet UIView *botView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *botViewHeight;

@property (strong, nonatomic) NSString* productId;
@property (assign, nonatomic) BOOL isEnough;

@end

@implementation DeriveDetailController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if (self.schemaArgu[@"id"]) {
        self.productId = [self.schemaArgu objectForKey:@"id"];
    }
    if (self.schemaArgu[@"isEnough"]) {
        self.isEnough = [[self.schemaArgu objectForKey:@"isEnough"] boolValue];
    }
    [self webViewInit];
    // Do any additional setup after loading the view.
}
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:YES];
    
    [self subviewStyle];
    [self subviewBind];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - private methods
-(void)webViewInit {
    
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
    
}
-(void)gain {
    //TODO:赚积分
}


@end
