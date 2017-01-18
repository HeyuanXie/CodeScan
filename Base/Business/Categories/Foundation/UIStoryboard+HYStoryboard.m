//
//  UIStoryboard+HYStoryboard.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIStoryboard+HYStoryboard.h"

@implementation UIStoryboard (HYStoryboard)
+ (UIStoryboard *)mainStoryboard{
    return [UIStoryboard storyboardWithName:@"Main" bundle:nil];
}

+ (UIStoryboard *)sortStoryboard{
    return [UIStoryboard storyboardWithName:@"Sort" bundle:nil];
}

+ (UIStoryboard *)cartStoryboard{
    return [UIStoryboard storyboardWithName:@"Cart" bundle:nil];
}

+ (UIStoryboard *)mineStoryboard{
    return [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
}

+ (UIStoryboard *)loginStoryboard{
    return [UIStoryboard storyboardWithName:@"Login" bundle:nil];
}
@end
