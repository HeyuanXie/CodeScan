//
//  NSString+Extension.m
//  Practice
//
//  Created by 谢河源 on 16/9/29.
//  Copyright © 2016年 heyuan. All rights reserved.
//

#import "NSString+Extension.h"

@implementation NSString (Extension)

-(CGSize)sizeWithAttributeString:(NSAttributedString *)attributedString maxWidth:(CGFloat)maxWidth{
    CGRect rect = [attributedString boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect.size;
}

-(CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth{
    NSAttributedString* attributedString = [[NSAttributedString alloc] initWithString:self attributes:@{NSFontAttributeName:font}];
    CGRect rect  = [attributedString boundingRectWithSize:CGSizeMake(maxWidth, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    return rect.size;
}

-(CGSize)sizeWithFont:(UIFont *)font maxWidth:(CGFloat)maxWidth lines:(int)lines{
    CGSize size = [self sizeWithFont:font maxWidth:maxWidth];
    NSString* str = @"a你";
    CGSize simple = [str sizeWithAttributes:@{NSFontAttributeName:font}];
    size.height = MIN(simple.height * (CGFloat)lines, size.height);
    return size;
}

-(NSAttributedString *)attributedStringWithString:(NSString *)string andWithColor:(UIColor *)color {
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    NSRange range = [self rangeOfString:string];
    [attributedString addAttribute:NSForegroundColorAttributeName value:defaultTextColor range:NSMakeRange(0, range.location)];
    [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    [attributedString addAttribute:NSForegroundColorAttributeName value:defaultTextColor range:NSMakeRange(range.length, self.length-(range.length+range.location))];
    return attributedString;
}

-(NSAttributedString *)attributedStringWithStrings:(NSArray *)strings andWithColors:(NSArray *)colors{
    NSMutableAttributedString* attributedString = [[NSMutableAttributedString alloc] initWithString:self];
    [attributedString addAttribute:NSForegroundColorAttributeName value:defaultTextColor range:NSMakeRange(0, self.length)];
    int i = 0;
    for (NSString* string in strings) {
        NSRange range = [self rangeOfString:string];
        UIColor* color = colors[i++];
        [attributedString addAttribute:NSForegroundColorAttributeName value:color range:range];
    }
    return attributedString;
}


-(NSMutableAttributedString*)addAttribute:(NSArray *)attributes values:(NSArray *)values subStrings:(NSArray *)subStrings {
    NSMutableAttributedString* mAttrStr = [[NSMutableAttributedString alloc] initWithString:self];
    for (int i=0; i<attributes.count; i++) {
        NSRange range = [self rangeOfString:subStrings[i]];
        [mAttrStr addAttribute:attributes[i] value:values[i] range:range];
    }
    return mAttrStr;
}

@end
