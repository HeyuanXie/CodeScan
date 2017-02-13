//
//  HYAddressController.h
//  Base
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseTableViewController.h"

@interface HYAddressController : BaseTableViewController

@property(nonatomic,assign) BOOL isFilter;  //是否显示在其他VC上，如果为YES则右上角显示“关闭”按钮
@property(nonatomic,assign) BOOL showAllCountry;    //是否显示全国

@property(nonatomic,copy)void(^selectAddress)(NSString* address, NSString* areaCode);
@property(nonatomic,copy)void(^filterDismiss)();

@end
