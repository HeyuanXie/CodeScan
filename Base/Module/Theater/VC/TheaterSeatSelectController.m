//
//  TheaterSeatSelectController.m
//  Base
//
//  Created by admin on 2017/3/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterSeatSelectController.h"
#import "TheaterCommitOrderController.h"
#import "TheaterSeatView.h"
#import "NSString+Extension.h"

@interface TheaterSeatSelectController ()
@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@property (weak, nonatomic) IBOutlet UIScrollView *seatScroll;
@property (weak, nonatomic) IBOutlet UIView *seatSelectV;

@property (strong, nonatomic) NSMutableArray* selectArray;

@end

@implementation TheaterSeatSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self subviewStyle];
    self.selectArray = [@[@"1",@"2",@"3"] mutableCopy];
    [self reloadSeatScrollView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reSelect:(id)sender {
    NSArray* viewControllers = self.navigationController.viewControllers;
    NSUInteger count = viewControllers.count;
    if (count > 3) {
        UIViewController* vc = self.navigationController.viewControllers[count-3];
        [self.navigationController popToViewController:vc animated:YES];
    }
}

- (IBAction)comfirm:(id)sender {
    
    TheaterCommitOrderController* vc = (TheaterCommitOrderController*)VIEWCONTROLLER(kTheaterCommitOrderController);
    vc.selectArray = self.selectArray;
    vc.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:vc animated:YES];
}


#pragma mark - private methods
-(NSMutableArray *)selectArray {
    if (!_selectArray) {
        _selectArray = [NSMutableArray array];
    }
    return _selectArray;
}

-(void)subviewStyle {
    
    self.descLbl.text = self.desc;
    self.seatScroll.showsVerticalScrollIndicator = NO;
    self.seatScroll.showsHorizontalScrollIndicator = NO;
    
    NSString* price = @"340",*count = @"3";
    NSString* text = [NSString stringWithFormat:@"¥%@(%@张)",price,count];
    self.priceLbl.attributedText = [text addAttribute:@[NSFontAttributeName,NSForegroundColorAttributeName,NSFontAttributeName,NSForegroundColorAttributeName] values:@[[UIFont systemFontOfSize:13],[UIColor hyRedColor],[UIFont systemFontOfSize:19],[UIColor hyRedColor]] subStrings:@[@"¥",@"¥",price,price]];
}

-(void)dataInit {
    //TODO:获取座位数据
    
}

-(void)reloadSeatScrollView {
    for (UIView* subview in self.seatScroll.subviews) {
        [subview removeFromSuperview];
    }
    for (int i=0; i<self.selectArray.count; i++) {
        id model = self.selectArray[i];
        TheaterSeatView* seatView = LOADNIB(@"TheaterUseView", 2);
        [HYTool configViewLayer:seatView withColor:[UIColor hySeparatorColor]];
        seatView.frame = CGRectMake(12+(106+7)*i, 0, 104, 33.5);
        [seatView configSeatView:model];
        [seatView setDeleteClick:^{
            [self.selectArray removeObjectAtIndex:i];
            [self reloadSeatScrollView];
        }];
        [self.seatScroll addSubview:seatView];
    }
    self.seatScroll.contentSize = CGSizeMake(12+(104+7)*self.selectArray.count, 0);
}

@end
