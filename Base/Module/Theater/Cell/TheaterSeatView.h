//
//  TheaterSeatView.h
//  Base
//
//  Created by admin on 2017/3/24.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TheaterSeatView : UIView

@property(nonatomic,copy)void (^deleteClick)();


-(void)configSeatView:(id)model;

@end
