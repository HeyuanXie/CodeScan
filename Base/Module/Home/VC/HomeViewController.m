//
//  HomeViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HomeViewController.h"
#import <UIView+BlocksKit.h>

@interface HomeViewController ()

@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backItemHidden = YES;
    
    [self initUI];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initUI {
    
    UIView *v1 = [[UIView alloc] init];
    v1.backgroundColor = [UIColor yellowColor];
    [self.view addSubview:v1];
    [v1 autoPinEdgeToSuperviewEdge:ALEdgeTop withInset:20];
    [v1 autoPinEdgeToSuperviewEdge:ALEdgeLeft withInset:20];
    [v1 autoSetDimensionsToSize:CGSizeMake(80, 80)];
    [v1 bk_whenTapped:^{
        NSLog(@"bk_tapped");
        APPROUTE(kTestViewController)
    }];
    
    UIView *v2 = [UIView newAutoLayoutView];
    v2.backgroundColor = [UIColor greenColor];
    [self.view addSubview:v2];
    [v2 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:v1];
    [v2 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:v1];
    [v2 autoAlignAxis:ALAxisHorizontal toSameAxisOfView:v1];
    [v2 autoPinEdge:ALEdgeLeft toEdge:ALEdgeRight ofView:v1];
    [v2 bk_whenTapped:^{

    }];

    
    UIView* v3 = [UIView newAutoLayoutView];
    v3.backgroundColor = [UIColor blueColor];
    [self.view addSubview:v3];
    [v3 autoPinEdge:ALEdgeTop toEdge:ALEdgeBottom ofView:v2];
    [v3 autoMatchDimension:ALDimensionWidth toDimension:ALDimensionWidth ofView:v2];
    [v3 autoMatchDimension:ALDimensionHeight toDimension:ALDimensionHeight ofView:v2];
    [v3 autoAlignAxis:ALAxisVertical toSameAxisOfView:v2];
    [v3 bk_whenTapped:^{
        DLog(@"bk_tapped");
        APPROUTE(kLoginViewController);
    }];

}

-(void)testUIViewLayout {
    
}


@end
