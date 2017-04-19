//
//  TheaterSeatPreviewController.m
//  Base
//
//  Created by admin on 2017/3/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterSeatPreviewController.h"
#import "TheaterSeatSelectController.h"
#import "NSDate+HYFormat.h"

@interface TheaterSeatPreviewController ()<FVSeatsPickerDelegate>

@property (strong, nonatomic) FVSeatsPicker* seatsPicker;
@property (nonatomic, assign) int seatMaxX;
@property (nonatomic, assign) int seatMaxY;

@property (weak, nonatomic) IBOutlet UILabel *descLbl;
@property (weak, nonatomic) IBOutlet UIScrollView *botScrollV;
@property (weak, nonatomic) IBOutlet UIView *seatSelectV;

@property (strong,nonatomic) NSString* theatreName;
@property (strong,nonatomic) NSString* playName;
@property (strong,nonatomic) NSString* playDate;
@property (strong,nonatomic) NSString* language;
@property (strong,nonatomic) NSString* playTime;

@property (assign, nonatomic) NSInteger hallId;
@property (assign, nonatomic) NSInteger timeId;
@property (strong, nonatomic) NSMutableArray* seatList;
@property (strong, nonatomic) NSMutableArray* priceList;

@end

@implementation TheaterSeatPreviewController

- (void)viewDidLoad {
    [super viewDidLoad];

    if (self.schemaArgu[@"theatre_name"]) {
        self.theatreName = [self.schemaArgu objectForKey:@"theatre_name"];
    }
    if (self.schemaArgu[@"play_name"]) {
        self.playName = [[[self.schemaArgu objectForKey:@"play_name"] stringByReplacingOccurrencesOfString:@"《" withString:@""] stringByReplacingOccurrencesOfString:@"》" withString:@""];
    }
    if (self.schemaArgu[@"play_date"]) {
        self.playDate = [self.schemaArgu objectForKey:@"play_date"];
        if ([self.playDate isEqualToString:[HYTool dateStringWithFormatter:@"yyyy-MM-dd"]]) {
            self.playDate = @"今天";
        }else{
            self.playDate = [NSDate dateStringWithString:self.playDate inputFormat:@"yyyy-MM-dd" outputFormat:@"MM-dd"];
        }
    }
    if (self.schemaArgu[@"lauguage"]) {
        self.language = [self.schemaArgu objectForKey:@"language"];
    }
    if (self.schemaArgu[@"play_time"]) {
        self.playTime = [self.schemaArgu objectForKey:@"play_time"];
    }
    if (self.schemaArgu[@"hall_id"]) {
        self.hallId = [[self.schemaArgu objectForKey:@"hall_id"] integerValue];
    }
    if (self.schemaArgu[@"time_id"]) {
        self.timeId = [[self.schemaArgu objectForKey:@"time_id"] integerValue];
    }

    self.title = self.theatreName;
    self.descLbl.text = [NSString stringWithFormat:@"%@ | %@ %@ %@",_playName,_playDate,_playTime,_language];
    
    [self configSeatsPicker];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)reSelect:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
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
    DLog(@"%s---%@",__func__,seatInfo);
}
- (void)seatsPicker:(FVSeatsPicker* )picker didDeselectSeat:(FVSeatItem *)seatInfo
{
    DLog(@"%s---%@",__func__,seatInfo);
}

- (void)selectionDidChangeInSeatsPicker:(FVSeatsPicker *)picker
{
    DLog(@"%s",__func__);
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
    
    [APIHELPER theaterSeatDetail:self.hallId timeId:self.timeId complete:^(BOOL isSuccess, NSDictionary *responseObject, NSError *error) {
        if (isSuccess) {
            for (NSDictionary* dict in responseObject[@"data"][@"seat_list"]) {
                FVSeatItem* seatsInfo = [FVSeatItem new];
                seatsInfo.seatId = [dict intValueForKey:@"ps_id"];
                seatsInfo.seatName = [dict stringForKey:@"seat_name"];
                seatsInfo.price = [dict intValueForKey:@"market_price"];
                seatsInfo.col = [dict intValueForKey:@"seat_y"];
                seatsInfo.row = [dict intValueForKey:@"seat_x"];
                seatsInfo.seatStatus = [dict intValueForKey:@"status"];
                seatsInfo.coordinateX = [dict intValueForKey:@"seat_sort"];
                seatsInfo.coordinateY = [dict intValueForKey:@"seat_x"];
                [self.seatList addObject:seatsInfo];
            }
            
            [self.priceList addObjectsFromArray:responseObject[@"data"][@"price_list"]];
            self.seatMaxX = [responseObject[@"data"][@"hall_info"][@"upright"] intValue];
            self.seatMaxY = [responseObject[@"data"][@"hall_info"][@"hall_rows"] intValue];
            [self botViewInit];
            [self fillDataToSeatsSelector];
        }else{
            [self showMessage:error.userInfo[NSLocalizedDescriptionKey]];
        }
    }];
}

-(void)botViewInit {
    
    CGFloat width = 120,height = 60;
    CGFloat padding = (kScreen_Width-self.priceList.count*width) <= 0 ? 0 : (kScreen_Width-self.priceList.count*width)/(self.priceList.count+1);
    for (int i=0; i<self.priceList.count; i++) {
        NSDictionary* data = self.priceList[i];
        UIView* priceView = LOADNIB(@"TheaterUseView", 3);
        [priceView viewWithTag:1000].backgroundColor = [UIColor colorWithString:data[@"seat_color"]];
        ((UILabel*)[priceView viewWithTag:1001]).text = [NSString stringWithFormat:@"%@元",data[@"real_price"]];
        priceView.frame = CGRectMake(padding+(width+padding)*i, 0, width, height);
        [self.botScrollV addSubview:priceView];
    }
    self.botScrollV.contentSize = CGSizeMake(width*self.priceList.count, 0);
}

-(void)configSeatsPicker {
    _seatsPicker = ({
        FVSeatsPicker* picker = [FVSeatsPicker new];
        picker.seatsDelegate = self;
        picker.cellSize = CGSizeMake(25, 25);
        picker.zoomScale = 0.5;
        // 你可以在这里设置图片，同时你也可以不设置FVSeatsPicker内部会自动设置默认的图片，如果设置新的图片将会采用最新设置的图片
        [picker setImage:[UIImage imageNamed:@"座位状态_可选"] forState:UIControlStateNormal];
        [picker setImage:[UIImage imageNamed:@"座位状态_不可选"] forState:UIControlStateDisabled];
        [picker setImage:[UIImage imageNamed:@"座位状态_已选"] forState:UIControlStateSelected];
        [self.seatSelectV addSubview:picker];
        picker;
    });
    [_seatsPicker autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
    UIButton* btn = [HYTool getButtonWithFrame:CGRectZero title:@"" titleSize:0 titleColor:nil backgroundColor:nil blockForClick:^(id sender) {
        TheaterSeatSelectController* vc = (TheaterSeatSelectController*)VIEWCONTROLLER(kTheaterSeatSelectController);
        vc.desc = self.descLbl.text;
        vc.title = self.title;
        vc.timeId = self.timeId;
        vc.hallId = self.hallId;
        vc.seatMaxX = self.seatMaxX;
        vc.seatMaxY = self.seatMaxY;
        vc.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:vc animated:YES];
    }];
    [self.seatSelectV addSubview:btn];
    [btn autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsZero];
}

- (void)fillDataToSeatsSelector
{
    _seatsPicker.rowCount = _seatMaxX;
    _seatsPicker.colCount = _seatMaxY;
    _seatsPicker.seats = self.seatList;
    [_seatsPicker reloadData];
}

@end
