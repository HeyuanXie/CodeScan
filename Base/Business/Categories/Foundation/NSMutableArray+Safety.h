//
//  NSMutableArray+Safety.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSMutableArray (Safety)

-(void)safe_addObject:(id)object;
-(void)safe_addObjectsFromArray:(NSArray *)otherArray;

@end


@interface NSArray (Safety)

-(id)safe_objectAtIndex:(NSUInteger)index;

@end
