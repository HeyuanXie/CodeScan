//
//  TheaterSeatPreviewController.m
//  Base
//
//  Created by admin on 2017/3/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterSeatPreviewController.h"
#import "TheaterSeatSelectController.h"

@interface TheaterSeatPreviewController ()

@property (weak, nonatomic) IBOutlet UILabel *descLbl;

@end

@implementation TheaterSeatPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reSelect:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private methods
-(void)subviewStyle {
    
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    TheaterSeatSelectController* vc = (TheaterSeatSelectController*)VIEWCONTROLLER(kTheaterSeatSelectController);
    vc.desc = @"场次介绍";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
