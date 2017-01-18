//
//  NSDictionary+Safety.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "NSDictionary+Safety.h"

@implementation NSDictionary (Safety)

-(id)safe_objectForKey:(id)aKey {
    id value = [self objectForKey:aKey];
    if (!value || [value isEqual:[NSNull null]]) {
        return nil;
    }
    return value;
}

-(NSString *)safe_stringForKey:(id)aKey {
    id value = [self objectForKey:aKey];
    if (!value || [value isEqual:[NSNull null]]) {
        return nil;
    }
    return [NSString stringWithFormat:@"%@",value];
}

-(NSInteger)safe_integerForKey:(id)aKey {
    NSString* value = [self safe_stringForKey:aKey];
    if ([self isPureInt:value]) {
        return value.integerValue;
    }
    return 0;
}

-(long long)safe_longlongIntForKey:(id)aKey {
    NSString* value = [self safe_stringForKey:aKey];
    if ([self isPureInt:value]) {
        return value.longLongValue;
    }
    return 0;
}

-(CGFloat)safe_floatForKey:(id)aKey {
    NSString* value = [self safe_stringForKey:aKey];
    if ([self isPureInt:value]) {
        return value.floatValue;
    }
    return 0.0f;
}

-(BOOL)isPureInt:(NSString*) string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    int val;
    return [scan scanInt:&val] && [scan isAtEnd];
}

-(BOOL)isPureFloat:(NSString *) string {
    NSScanner* scan = [NSScanner scannerWithString:string];
    float val;
    return [scan scanFloat:&val] && [scan isAtEnd];
}

@end


@implementation NSMutableDictionary (Safety)

-(void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey {
    if (anObject) {
        [self setObject:anObject forKey:aKey];
    }
}

-(void)safe_setValue:(id)value forKey:(NSString *)aKey {
    if (value) {
        [self setValue:value forKey:aKey];
    }
}

@end
