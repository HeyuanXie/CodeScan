//
//  UIViewController+Extension.h
//  Base
//
//  Created by admin on 2017/3/2.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIViewController (Extension)

- (void)addBackgroundImage:(NSString*)imageName frame:(CGRect)frame;

- (void)addBackgroundImageWithFrame:(CGRect)frame;


/**
 添加“消息” navigationItem
 */
- (void)configMessage;

/**
 添加两个navigationItems

 @param imageNames items‘ imageNames
 @param block1 first Item's block
 @param block2 second Items's block
 */
- (void)addDoubleNavigationItemsWithImages:(NSArray*)imageNames firstBlock:(void(^)())block1 secondBlock:(void(^)())block2;


/**
 弹出actionSheet选择已安装地图导航
 
 @param addressString 目的地址
 */
- (void)geocoderClick:(NSString *)addressString;

@end
