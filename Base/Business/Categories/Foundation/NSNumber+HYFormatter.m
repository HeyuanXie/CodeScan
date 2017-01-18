//
//  NSNumber+HYFormatter.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "NSNumber+HYFormatter.h"

@implementation NSNumber (HYFormatter)

- (NSString *)priceString {
    NSNumberFormatter *doubleValueWithMaxOneDecimalPlaces = [[NSNumberFormatter alloc] init];
    [doubleValueWithMaxOneDecimalPlaces setNumberStyle:NSNumberFormatterDecimalStyle];
    [doubleValueWithMaxOneDecimalPlaces setMaximumFractionDigits:2];
    return [doubleValueWithMaxOneDecimalPlaces stringFromNumber:self];
}

@end
