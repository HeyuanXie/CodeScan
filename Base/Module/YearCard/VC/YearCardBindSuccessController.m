//
//  YearCardBindSuccessController.m
//  Base
//
//  Created by admin on 2017/3/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "YearCardBindSuccessController.h"

@interface YearCardBindSuccessController ()

@property(nonatomic,strong)NSString* deadline;
@property (weak, nonatomic) IBOutlet UILabel *timeLbl;

@end

@implementation YearCardBindSuccessController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.schemaArgu objectForKey:@"deadline"]) {
        self.deadline = [self.schemaArgu objectForKey:@""];
    }
    [self subviewStyle];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - IBActions
- (IBAction)leave:(id)sender {
    
    APPROUTE(kHomeViewController);
}

-(void)subviewStyle {
    self.timeLbl.text = [NSString stringWithFormat:@"有效期至: %@",self.deadline];
}

@end
