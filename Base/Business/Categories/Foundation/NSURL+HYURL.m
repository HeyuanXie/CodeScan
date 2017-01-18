//
//  NSURL+HYURL.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "NSURL+HYURL.h"

@implementation NSURL (HYURL)

- (NSURL *)hyURLForImageOfSize:(CGSize)size quality:(CGFloat)quality
{
    CGFloat scale = [UIScreen mainScreen].scale;
    NSString *queryString = [NSString stringWithFormat:@"%@w_%@h_%@q",
                             @(lroundf(size.width*scale)),
                             @(lroundf(size.height*scale)),
                             @(quality)];
    return [self hyURLByAppendQueryString:queryString];
}

- (NSURL *)hyURLByAppendQueryString:(NSString *)queryString
{
    if (![queryString length]) {
        return self;
    }
    NSString *URLString = [[NSString alloc] initWithFormat:@"%@@%@", [self absoluteString], queryString];
    NSURL *theURL = [NSURL URLWithString:URLString];
    return theURL;
}

@end
