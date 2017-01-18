//
//  BaseModel.h
//  Base
//
//  Created by admin on 2017/1/17.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <YYModel.h>

@interface NSArray (Model)

+ (NSArray *)yy_modelArrayWithClass:(Class)cls array:(NSArray *)arr;

@end

@interface BaseModel : NSObject

@end
