//
//  UIStoryboard+HYStoryboards.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIStoryboard+HYStoryboards.h"

@implementation UIStoryboard (HYStoryboards)

+ (UIStoryboard *)hyMineStoryboard {
    return [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
}

+ (UIStoryboard *)hyCartStoryboard {
    return [UIStoryboard storyboardWithName:@"Cart" bundle:nil];
}

+ (UIStoryboard *)hyMainStoryboard {
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard *)hyLoginStoryboard {
    return [UIStoryboard storyboardWithName:@"Login" bundle:nil];
}

+ (UIStoryboard *)hyDetailStoryboard {
    return [UIStoryboard storyboardWithName:@"Detail" bundle:nil];
}

@end
