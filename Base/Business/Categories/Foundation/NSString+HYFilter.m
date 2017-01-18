//
//  NSString+HYFilter.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "NSString+HYFilter.h"

@implementation NSString (HYFilter)

- (NSString *)filterFrontAndBackSpace{
    
    return [self stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

@end
