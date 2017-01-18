//
//  NSObject+Global.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "NSObject+Global.h"

@implementation NSObject (Global)

@end

#ifndef DEBUG
@implementation NSString (Global)
//防止数据解析  误以为NSNumber crash
- (NSString *)stringValue {return self;}
@end


@implementation NSNumber (Global)
//防止数据解析  误以为NSString length
- (NSUInteger)length
{
    return self.stringValue.length;
}
@end

@implementation NSArray (Global)
- (id)objectForKey:(NSString *)aKey{
    return nil;
}
@end

@implementation NSDictionary (Global)
- (id)objectAtIndex:(NSUInteger)index{
    return nil;
}
@end
#endif
