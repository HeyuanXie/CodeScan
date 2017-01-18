//
//  NSObject+Routes.m
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "NSObject+Routes.h"

@implementation NSObject (Routes)

-(NSString*)objSchema{
    return objc_getAssociatedObject(self, @selector(objSchema));
}

-(void)setObjSchema:(NSString *)schema{
    objc_setAssociatedObject(self, @selector(objSchema), schema, OBJC_ASSOCIATION_RETAIN);
}

-(NSDictionary*)schemaArgu
{
    return objc_getAssociatedObject(self, @selector(schemaArgu));
}
-(void)setSchemaArgu:(NSDictionary *)argu
{
    objc_setAssociatedObject(self, @selector(schemaArgu), argu, OBJC_ASSOCIATION_RETAIN);
}

@end
