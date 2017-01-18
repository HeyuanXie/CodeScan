//
//  UILabel+autoSize.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UILabel+autoSize.h"

@implementation UILabel (autoSize)

- (void)autoHeightWithWidth:(CGFloat)width {
    CGRect frame = self.frame;
    CGSize maxSize = CGSizeMake(width, 9999);
    
    //    NSLog(@"label width =  %f",maxSize.width);
    //计算大小
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    UIFont * font = [UIFont systemFontOfSize:14.f];
    NSDictionary * attributes = @{NSFontAttributeName : font,
                                  NSParagraphStyleAttributeName : paragraphStyle};
    
    CGSize  expectedSize = [self.text boundingRectWithSize:maxSize
                                                   options:NSStringDrawingUsesFontLeading|NSStringDrawingUsesLineFragmentOrigin
                                                attributes:attributes
                                                   context:nil].size;
    frame.size.height = expectedSize.height;
    
    //    NSLog(@"label height %f",frame.size.height);
    
    [self setFrame:frame];
}

@end
