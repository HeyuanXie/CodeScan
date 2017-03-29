//
//  NSString+HYUtilities.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (HYUtilities)

- (BOOL)hy_containsString:(NSString *)string;
- (NSDictionary *)hy_dictionaryByBreakParameterString;
- (NSDictionary *)hy_dictionaryByShareUrl;

- (NSString *)URLEncodedString;
- (NSString*)URLDecodedString;
- (NSString *)md5String;
- (NSString *)sha1String;

- (NSString *)phoneSeparatorString;

+ (NSString *)stringWithHtmlString:(NSString *)hString;

@end
