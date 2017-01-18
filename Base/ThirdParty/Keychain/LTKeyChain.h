//
//  LTKeyChain.h
//  KalaokRB
//
//  Created by Liuyu on 13-11-4.
//  Copyright (c) 2013年 fengguixian. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LTKeyChain : NSObject

// 保存数据
+ (void)save:(NSString *)key data:(id)data;

// 加载数据
+ (id)load:(NSString *)key;

// 删除数据
+ (void)delete:(NSString *)key;

@end
