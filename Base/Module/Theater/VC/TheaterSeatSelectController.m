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
#import "CouponModel.h"
#import "NSString+Extension.h"


@interface TheaterSeatSelectController ()<FVSeatsPickerDelegate>

@property (nonatomic, strong) FVSeatsPicker* seatsPicker;

@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UILabel *priceLbl;

@property (weak, nonatomic) IBOutlet UIScrollView *seatScroll;
@property (weak, nonatomic) IBOutlet UIView *seatSelectV;

@property (strong, nonatomic) NSMutableArray* selectArray;
@property (nonatomic, strong) NSMutableArray <FVSeatItem *>* seatsInfo;

@end

@implementation TheaterSeatSelectController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
//    if (self.schemaArgu[@"hall_id"]) {
//        self.hallId = [[self.schemaArgu objectForKey:@"hall_id"] integerValue];
//    }
//    if (self.schemaArgu[@"time_id"]) {
//        self.timeId = [[self.schemaArgu objectForKey:@"time_id"] integerValue];
//    }
    
    [self subviewStyle];
    [self reloadSeatScrollView];
    [self configSeatsPicker];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear: YES];
    
    [self.selectArray removeAllObjects];
    [self reloadSeatScrollView];
    [self configSeatsPicker];
    [self loadData];
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
    
    NSMutableArray* seatArr = [NSMutableArray array];
    for (FVSeatItem* seat in self.selectArray) {
        [seatArr addObject:@(seat.seatId)];
    }
    //锁定座位，成功后跳到付款页面
    [APIHELPER theaterSeatLock:self.timeId seats:seatArr complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            NSArray* coupons = [NSArray yy_modelArrayWithClass:[CouponModel class] array:responseObject[@"data"][@"coupon_list"][@"list"]];
            NSArray* yearCards = responseObject[@"data"][@"card_list"][@"list"];
            
            TheaterCommitOrderController* vc = (TheaterCommitOrderController*)VIEWCONTROLLER(kTheaterCommitOrderController);
            vc.selectArray = self.selectArray;
            vc.coupons = coupons;
            vc.yearCards = yearCards;
            vc.timeId = self.timeId;
            vc.timeLeft = [responseObject[@"data"][@"time_left"] intValue];
            vc.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:vc animated:YES];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

#pragma mark - FVSeatsPickerDelegate

- (BOOL)shouldSelectSeat:(FVSeatItem *)seatInfo inPicker:(FVSeatsPicker* )picker
{
    return YES;
}

- (BOOL)shouldDeselectSeat:(FVSeatItem *)seatInfo inPicker:(FVSeatsPicker* )picker
{
    return YES;
}

- (void)seatsPicker:(FVSeatsPicker* )picker didSelectSeat:(FVSeatItem *)seatInfo
{
    [self.selectArray addObject:seatInfo];
    [self reloadSeatScrollView];
    DLog(@"%s---%@",__func__,seatInfo);
}
- (void)seatsPicker:(FVSeatsPicker* )picker didDeselectSeat:(FVSeatItem *)seatInfo
{
    [self.selectArray removeObject:seatInfo];
    [self reloadSeatScrollView];
    DLog(@"%s---%@",__func__,seatInfo);
}

- (void)selectionDidChangeInSeatsPicker:(FVSeatsPicker *)picker
{
    DLog(@"%s",__func__);
}

#pragma mark - private methods
-(NSMutableArray<FVSeatItem *> *)seatsInfo {
    if (!_seatsInfo) {
        _seatsInfo = [NSMutableArray array];
    }
    return _seatsInfo;
}

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
}

//选择或删除座位，刷新seatScrollView
-(void)reloadSeatScrollView {
    for (UIView* subview in self.seatScroll.subviews) {
        [subview removeFromSuperview];
    }
    CGFloat total = 0.0;
    for (int i=0; i<self.selectArray.count; i++) {
        FVSeatItem* seatInfo = self.selectArray[i];
        TheaterSeatView* seatView = LOADNIB(@"TheaterUseView", 2);
        [HYTool configViewLayer:seatView withColor:[UIColor hySeparatorColor]];
        seatView.frame = CGRectMake(12+(106+7)*i, 0, 104, 33.5);
        [seatView configSeatView:seatInfo];
        [seatView setDeleteClick:^{
            [self.selectArray removeObjectAtIndex:i];
            [self.seatsPicker tryToChangeSelectionOfSeat:seatInfo];
            [self reloadSeatScrollView];
        }];
        [self.seatScroll addSubview:seatView];
        total = total + seatInfo.realPrice;
    }
    self.seatScroll.contentSize = CGSizeMake(12+(104+7)*self.selectArray.count, 0);
    
    if (self.selectArray.count == 0) {
        self.priceLbl.text = @"";
        return;
    }
    NSString* price = [NSString stringWithFormat:@"%.2f",total],*count = [NSString stringWithFormat:@"%ld",self.selectArray.count];
    NSString* text = [NSString stringWithFormat:@"¥%@(%@张)",price,count];
    self.priceLbl.attributedText = [text addAttribute:@[NSFontAttributeName,NSForegroundColorAttributeName,NSFontAttributeName,NSForegroundColorAttributeName] values:@[[UIFont systemFontOfSize:13],[UIColor hyRedColor],[UIFont systemFontOfSize:19],[UIColor hyRedColor]] subStrings:@[@"¥",@"¥",price,price]];
}
 

//MARK: - 选座相关
-(void)configSeatsPicker {
    [_seatsPicker removeFromSuperview];
    _seatsPicker = nil;
    _seatsPicker = ({
        FVSeatsPicker* picker = [FVSeatsPicker new];
        picker.cellSize = CGSizeMake(25, 25);
        picker.minimumZoomScale = 0.5;
        picker.maximumZoomScale = 2;
        picker.seatsDelegate = self;
//        // 你可以在这里设置图片，同时你也可以不设置FVSeatsPicker内部会自动设置默认的图片，如果设置新的图片将会采用最新设置的图片
        [picker setImage:[UIImage imageNamed:@"座位状态_可选"] forState:UIControlStateNormal];
        [picker setImage:[UIImage imageNamed:@"座位状态_不可选"] forState:UIControlStateDisabled];
        [picker setImage:[UIImage imageNamed:@"座位状态_已选"] forState:UIControlStateSelected];
        [self.seatSelectV addSubview:picker];
        picker;
    });
    [_seatsPicker autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

-(void)loadData {

    [APIHELPER theaterSeatDetail:self.hallId timeId:self.timeId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            for (NSDictionary* dict in responseObject[@"data"][@"seat_list"]) {
                FVSeatItem* seatsInfo = [FVSeatItem new];
                seatsInfo.seatId = [dict intValueForKey:@"ps_id"];
                seatsInfo.seatName = [dict stringForKey:@"seat_name"];
                seatsInfo.realPrice = [dict[@"real_price"] floatValue];
                seatsInfo.marketPrice = [dict[@"market_price"] floatValue];
                seatsInfo.cardPrice = [dict[@"card_price"] floatValue];
                seatsInfo.col = [dict intValueForKey:@"seat_y"];
                seatsInfo.row = [dict intValueForKey:@"seat_x"];
                seatsInfo.seatStatus = [dict intValueForKey:@"status"];
                seatsInfo.coordinateX = [dict intValueForKey:@"seat_sort"];
                seatsInfo.coordinateY = [dict intValueForKey:@"seat_x"];
                [self.seatsInfo addObject:seatsInfo];
            }
            
            self.seatMaxX = [responseObject[@"data"][@"hall_info"][@"hall_rows"] intValue];
            self.seatMaxY = [responseObject[@"data"][@"hall_info"][@"upright"] intValue];
            [self fillDataToSeatsSelector];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
    
    [self fillDataToSeatsSelector];
}

- (void)fillDataToSeatsSelector
{
    _seatsPicker.rowCount = _seatMaxX;
    _seatsPicker.colCount = _seatMaxY;
    _seatsPicker.seats = _seatsInfo;
    [_seatsPicker reloadData];
}

@end
