//
//  NSObject+Swizzling.m
//  ProjectRefactoring
//
//  Created by 刘硕 on 2016/11/10.
//  Copyright © 2016年 刘硕. All rights reserved.
//

#import "NSObject+Swizzling.h"
@implementation NSObject (Swizzling)

+(void)methodSwizzlingWithOriginalSelector:(SEL)originalSelector bySwizzledSelector:(SEL)swizzledSelector{
    Class class = [self class];
    //原有的方法
    Method originalMethod = class_getInstanceMethod(class, originalSelector);
    //用来替换的方法
    Method swizzledMethod = class_getInstanceMethod(class, swizzledSelector);
    //给原SEL添加IMP,便面原SEL没有实现IMP的情况
    BOOL didAddMethod = class_addMethod(class, originalSelector, method_getImplementation(swizzledMethod), method_getTypeEncoding(swizzledMethod));
    if (didAddMethod) {
        //添加成功,原SEL没有实现IMP，将原SEL的IMP替换到交换的SEL的IMP
        class_replaceMethod(class, swizzledSelector, method_getImplementation(originalMethod), method_getTypeEncoding(originalMethod));
    }else{
        //添加失败,说明原SEL实现了IMP，直接交换两个SEL的IMP即可
        method_exchangeImplementations(originalMethod, swizzledMethod);
    }
    
}

@end
