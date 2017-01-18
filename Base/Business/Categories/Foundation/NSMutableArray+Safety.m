//
//  NSMutableArray+Safety.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "NSMutableArray+Safety.h"

@implementation NSMutableArray (Safety)

-(void)safe_addObject:(id)object {
    if (object) {
        [self addObject:object];
    }
}

-(void)safe_addObjectsFromArray:(NSArray *)otherArray {
    if (otherArray && [otherArray count]) {
        [self addObjectsFromArray:otherArray];
    }
}

@end

@implementation NSArray (Safety)

-(id)safe_objectAtIndex:(NSUInteger)index {
    if (([self count]-1) >= index) {
        return [self objectAtIndex:index];
    }
    return nil;
}

@end


