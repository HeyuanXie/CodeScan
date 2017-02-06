//
//  ThreeImgCell.h
//  Base
//
//  Created by admin on 2017/1/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ThreeImgCell : UITableViewCell

@property(nonatomic,copy)void(^policy)();
@property(nonatomic,copy)void(^guide)();
@property(nonatomic,copy)void(^demand)();

+(NSString*)identify;

@end
