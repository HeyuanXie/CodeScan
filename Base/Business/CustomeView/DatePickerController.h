//
//  DatePickerController.h
//  GreatTigerCustom
//
//  Created by hitao on 16/4/18.
//  Copyright © 2016年 GreatTiger. All rights reserved.
//

#import "BaseViewController.h"

@interface DatePickerController : BaseViewController

@property (nonatomic, copy) void(^selectDate)(NSString *dateString);
@end
