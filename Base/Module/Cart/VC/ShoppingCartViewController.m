//
//  ShoppingCartViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ShoppingCartViewController.h"
#import "BlockView.h"

@interface ShoppingCartViewController ()

@property(nonatomic,weak)IBOutlet BlockView* blockView;

@end

@implementation ShoppingCartViewController

- (IBAction)startAction:(id)sender {
    
    CGFloat to = 64;
    [self.blockView startAnimation];
    [UIView animateWithDuration:1 delay:0 usingSpringWithDamping:0.85 initialSpringVelocity:0 options:0 animations:^{
        self.blockView.center = CGPointMake(self.blockView.center.x, to);
    } completion:^(BOOL finished) {
        [self.blockView completeAnimation];
    }];
}


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.backItemHidden = YES;
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
