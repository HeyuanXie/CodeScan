//
//  SkillApplySucceedController.m
//  Base
//
//  Created by admin on 2017/3/14.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SkillApplySucceedController.h"

@interface SkillApplySucceedController ()

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UIButton *informationBtn;
@property (weak, nonatomic) IBOutlet UIButton *canvassBtn;

@end

@implementation SkillApplySucceedController

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

#pragma mark - private methods
- (void)subviewStyle {
    [HYTool configViewLayer:self.informationBtn withColor:[UIColor hyBarTintColor]];
    [HYTool configViewLayer:self.canvassBtn withColor:[UIColor hyBarTintColor]];
}

- (void)subviewBind {
    [self.informationBtn addTarget:self action:@selector(seeInformation) forControlEvents:UIControlEventTouchUpInside];
    [self.canvassBtn addTarget:self action:@selector(askSupport) forControlEvents:UIControlEventTouchUpInside];
}
-(void)seeInformation {
    //TODO:
}
-(void)askSupport {
    //TODO:
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
