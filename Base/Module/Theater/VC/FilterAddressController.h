//
//  FilterAddressController.h
//  Base
//
//  Created by admin on 2017/3/29.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FilterAddressController : UITableViewController

@property(nonatomic,copy)void (^selectCity)(NSString* city);


@end
