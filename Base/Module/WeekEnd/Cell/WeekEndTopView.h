//
//  WeekEndTopView.h
//  Base
//
//  Created by admin on 2017/3/21.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WeekEndTopView : UIView

@property (weak, nonatomic) IBOutlet UIView *firstView;
@property (weak, nonatomic) IBOutlet UIView *secondView;
@property (weak, nonatomic) IBOutlet UIView *thirdView;
@property (weak, nonatomic) IBOutlet UIView *Line;

@property(nonatomic,copy)void (^firstClick)();
@property(nonatomic,copy)void (^secondClick)();
@property(nonatomic,copy)void (^thirdClick)();

@end
