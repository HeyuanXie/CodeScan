//
//  NSDictionary+Safety.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Safety)

-(id)safe_objectForKey:(id)aKey;
-(NSString*)safe_stringForKey:(id)aKey;
-(NSInteger)safe_integerForKey:(id)aKey;
-(long long int)safe_longlongIntForKey:(id)aKey;
-(CGFloat)safe_floatForKey:(id)aKey;

@end

@interface NSMutableDictionary (Safety)

-(void)safe_setObject:(id)anObject forKey:(id<NSCopying>)aKey;
-(void)safe_setValue:(id)value forKey:(NSString *)aKey;

@end
