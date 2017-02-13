//
//  ZMDHomeData.m
//  Base
//
//  Created by admin on 2017/2/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "ZMDHomeData.h"

@implementation ZMDHomeData

+(NSDictionary *)modelContainerPropertyGenericClass {
    return @{@"slide":[ZMDArticle class],
             @"policy":[ZMDArticle class],
             @"news":[ZMDArticle class]};
}
@end
