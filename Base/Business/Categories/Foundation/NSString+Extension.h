//
//  NSString+Extension.h
//  Practice
//
//  Created by 谢河源 on 16/9/29.
//  Copyright © 2016年 heyuan. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (Extension)

//得到字符串的size
-(CGSize)sizeWithAttributeString:(NSAttributedString*)attributedString maxWidth:(CGFloat)width;
-(CGSize)sizeWithFont:(UIFont*)font maxWidth:(CGFloat)width;
-(CGSize)sizeWithFont:(UIFont*)font maxWidth:(CGFloat)width lines:(int)lines;

//属性字符串
-(NSAttributedString*)attributedStringWithString:(NSString*)string andWithColor:(UIColor*)color;
-(NSAttributedString*)attributedStringWithStrings:(NSArray*) strings andWithColors:(NSArray*)colors;

-(NSMutableAttributedString*)addAttribute:(NSArray *)attributes values:(NSArray *)values subStrings:(NSArray *)subStrings;

@end
