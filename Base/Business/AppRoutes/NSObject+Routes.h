//
//  NSObject+Routes.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (Routes)

//JLRoutes跳转时传递的参数
@property(nonatomic,strong,getter=objSchema,setter=setObjSchema:) NSString *objSchema;
@property(nonatomic,strong,getter=schemaArgu,setter=setSchemaArgu:) NSDictionary *schemaArgu;

@end
