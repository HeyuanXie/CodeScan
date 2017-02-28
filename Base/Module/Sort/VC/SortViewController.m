//
//  SortViewController.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SortViewController.h"
#import "CustomCircleView.h"

@interface SortViewController ()

@property(nonatomic,strong)CADisplayLink* displayLink;
@property(nonatomic,strong)CustomCircleView* circleView;
@property (weak, nonatomic) IBOutlet UITextField *rateTf;

@end

@implementation SortViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.backItemHidden = YES;
    self.view.backgroundColor = [UIColor hyViewBackgroundColor];
    
    UIButton* btn = [UIButton buttonWithType:UIButtonTypeCustom];
    btn.frame = CGRectMake(0, 0, 80, 40);
    btn.center = self.view.center;
    btn.backgroundColor = [UIColor hyGrayTextColor];
    [btn setTitle:@"变色" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    btn.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        [self updateBackgroundColor];
        return [RACSignal empty];
    }];
    [self.view addSubview:btn];
    btn.hidden = YES;
    
    [self customCircleView];
}

#pragma mark - event 
- (IBAction)start:(id)sender {
    _circleView.rate = [_rateTf.text integerValue];
    [_circleView startAnimation];
}

#pragma mark - private methods
-(CADisplayLink *)displayLink {
    if (!_displayLink) {
        _displayLink = [CADisplayLink displayLinkWithTarget:self selector:@selector(updateBackgroundColor)];
        _displayLink.paused = YES;
        [_displayLink addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSRunLoopCommonModes];
    }
    return _displayLink;
}

-(void)updateBackgroundColor {
    [UIView animateWithDuration:2.0 animations:^{
        self.displayLink.paused = NO;
        self.view.backgroundColor = [UIColor redColor];
    } completion:^(BOOL finished) {
        self.displayLink.paused = YES;
        [self.displayLink invalidate];
        self.displayLink = nil;
    }];
}

- (void)customCircleView {
    _circleView = [[CustomCircleView alloc] initWithFrame:CGRectMake((kScreen_Width-150)/2, 100, 150, 150)];
    [self.view addSubview:_circleView];
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
