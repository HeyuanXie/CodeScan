//
//  NSObject+Global.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Global)

@end


#ifndef DEBUG
@interface NSString (Global)
//防止数据解析  误以为NSNumber crash
- (NSString *)stringValue;
@end


@interface NSNumber (Global)
//防止数据解析  误以为NSString length
- (NSUInteger)length;
@end

@interface NSArray (Global)
- (id)objectForKey:(NSString *)aKey;
@end

@interface NSDictionary (Global)
- (id)objectAtIndex:(NSUInteger)index;
@end
#endif
