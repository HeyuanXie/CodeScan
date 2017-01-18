//
//  NSString+HYMobileInsertInterval.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "NSString+HYMobileInsertInterval.h"
#import "NSString+TSRegularExpressionUtil.h"

@implementation NSString (HYMobileInsertInterval)


- (NSString *)HTMobileInsertInterval{
    NSMutableString * MTStr = [NSMutableString stringWithString:self];
    if (MTStr.length == 11) {
        [MTStr insertString:@" " atIndex:3];
        [MTStr insertString:@" " atIndex:8];
    }
    return [NSString stringWithString:MTStr];
}
- (NSString *)HtIdCardNumInsertInterval{
    if (self.length == 18) {
        return [self stringByReplacingCharactersInRange:NSMakeRange(6, 8) withString:@"********"];
    }else{
        return self;
    }
}
- (NSMutableAttributedString *)htPriceUnitTreatment{
    
    NSString * moneyStr = [NSString stringWithFormat:@"¥%@",self];
    
    UIFont * font = [UIFont fontWithName:@"MuseoSans-500" size:10];
    
    NSDictionary * attrsDic = @{
                                NSFontAttributeName:font
                                };
    NSMutableAttributedString * moneyCharacterStr = [[NSMutableAttributedString alloc] initWithString:moneyStr];
    
    [moneyCharacterStr setAttributes:attrsDic range:NSMakeRange(0, 1)];
    
    return moneyCharacterStr;
}


- (NSAttributedString *)fetchSpaceLineWithFont:(UIFont *) font WithLineSpace:(CGFloat ) lineSpace{
    
    if ([self isEmpty]) return nil;
    
    NSMutableAttributedString * attrString = [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle * pStyle = [[NSMutableParagraphStyle alloc] init];
    [pStyle setLineSpacing:lineSpace ? : 5.f];
    [pStyle setLineBreakMode:NSLineBreakByTruncatingTail];
    [attrString addAttribute:NSParagraphStyleAttributeName value:pStyle range:NSMakeRange(0, [self length])];
    [attrString addAttributes:@{NSFontAttributeName:font ? : [UIFont systemFontOfSize:14.f]} range:NSMakeRange(0, [self length])];
    
    return attrString;
    
}


@end
