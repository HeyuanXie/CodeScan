//
//  MBProgressHUD+hyHUD.h
//  test
//
//  Created by admin on 17/1/12.
//  Copyright © 2017年 admin. All rights reserved.
//

#import <MBProgressHUD/MBProgressHUD.h>

@interface MBProgressHUD (hyHUD)

+ (void)hy_showMessage: (NSString *)message inView: (UIView *)view;

+ (void)hy_showMessage:(NSString *)message inView:(UIView *)view completionBlock:(void(^)())completionBlock;

+ (MB_INSTANCETYPE)hy_showLoadingHUDAddedTo:(UIView *)view animated:(BOOL)animated;

@end
