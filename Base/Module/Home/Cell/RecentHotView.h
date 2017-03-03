//
//  RecentHotView.h
//  Base
//
//  Created by admin on 2017/3/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RecentHotView : UIView

@property(nonatomic,copy)void (^recentViewClick)();

@property (weak, nonatomic) IBOutlet UIImageView *imgV;
@property (weak, nonatomic) IBOutlet UILabel *desLbl;

+(CGSize)homeSize;
+(CGSize)showDetailSize;
@end
