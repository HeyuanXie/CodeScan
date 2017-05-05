//
//  TheaterSeatSelectController.h
//  Base
//
//  Created by admin on 2017/3/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseTableViewController.h"
#import "FVSeatsPicker.h"
#import "NSDictionary+FVExtension.h"

@interface TheaterSeatSelectController : BaseTableViewController

@property(strong,nonatomic)NSString* desc;  //剧名、时间、语种
@property(assign,nonatomic)NSInteger timeId;    //场次Id
@property(assign,nonatomic)NSInteger hallId;
@property(strong,nonatomic)NSString* playTime;
@property(strong,nonatomic)NSString* playName;
@property(strong,nonatomic)NSString* playImg;
@property(strong,nonatomic)NSString* address;

@property (nonatomic, assign) int seatMaxX;
@property (nonatomic, assign) int seatMaxY;


@end
