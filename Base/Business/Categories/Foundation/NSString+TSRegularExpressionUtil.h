//
//  NSString+TSRegularExpressionUtil.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, ValidateType) {
    ValidateTypeForMobile = 0,
    ValidateTypeForRealName,
    ValidateTypeForId,
    ValidateTypeForEmail,
    ValidateTypeForPassword,
    ValidateTypeForUsername,
    ValidateTypeForZipCode, // 邮政编码
    ValidateTypeForVerify,
    ValidateTypeForNone
};

@interface NSString (TSRegularExpressionUtil)

- (BOOL)validateWithValidateType:(ValidateType) type;

- (BOOL)isEmpty;

@end
