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
@property (weak, nonatomic) IBOutlet UIScrollView *botScrollV;

@property (strong, nonatomic) NSMutableArray* seatList;
@property (strong, nonatomic) NSMutableArray* priceList;


@end

@implementation TheaterSeatPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reSelect:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

#pragma mark - private methods
-(NSMutableArray *)seatList {
    if (!_seatList) {
        _seatList = [NSMutableArray array];
    }
    return _seatList;
}

-(NSMutableArray *)priceList {
    if (!_priceList) {
        _priceList = [NSMutableArray array];
    }
    return _priceList;
}

-(void)fetchData {
    //TODO:成功后
    [self botViewInit];
}

-(void)botViewInit {
    
    CGFloat width = 92,height = 60;
    CGFloat padding = (kScreen_Width-self.priceList.count*width) <= 0 ? 0 : (kScreen_Width-self.priceList.count*width)/(self.priceList.count+1);
    for (int i=0; i<self.priceList.count; i++) {
        NSDictionary* data = self.priceList[i];
        UIView* priceView = LOADNIB(@"TheaterUseView", 3);
        [priceView viewWithTag:1000].backgroundColor = [UIColor colorWithString:data[@"seat_color"]];
        ((UILabel*)[priceView viewWithTag:1001]).text = data[@"real_price"];
        priceView.frame = CGRectMake(padding+(width+padding)*i, 0, width, height);
        [self.botScrollV addSubview:priceView];
    }
    self.botScrollV.contentSize = CGSizeMake(width*self.priceList.count, 0);
}

-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    TheaterSeatSelectController* vc = (TheaterSeatSelectController*)VIEWCONTROLLER(kTheaterSeatSelectController);
    vc.desc = @"场次介绍";
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}

@end
