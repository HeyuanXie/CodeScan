//
//  MBProgressHUD+hyHUD.m
//  test
//
//  Created by admin on 17/1/12.
//  Copyright © 2017年 admin. All rights reserved.
//

#import "MBProgressHUD+hyHUD.h"

@implementation MBProgressHUD (hyHUD)

+ (void)hy_showMessage: (NSString *)message inView: (UIView *)view {
    [self hy_showMessage:message inView:view completionBlock:nil];
}

+ (void)hy_showMessage:(NSString *)message inView:(UIView *)view completionBlock:(void(^)())completionBlock {
    if (view) {
        MBProgressHUD* hud = [MBProgressHUD showHUDAddedTo:view animated:YES];
        hud.mode = MBProgressHUDModeText;
        hud.detailsLabel.font = [UIFont systemFontOfSize:16.0f];
        hud.detailsLabel.text = message;
        hud.removeFromSuperViewOnHide = YES;
        hud.completionBlock = completionBlock;
        [hud hideAnimated:YES afterDelay:HUD_MESSAGE_SHOWTIME];
    }
}

+ (MB_INSTANCETYPE)hy_showLoadingHUDAddedTo:(UIView *)view animated:(BOOL)animated {
    [self hideHUDForView:view animated:YES];
    return [self showHUDAddedTo:view animated:YES];
}

+ (MB_INSTANCETYPE)hy_showCustomeView: (UIView*)customView addedTo: (UIView*)view animated:(BOOL)animated {
    MBProgressHUD* hud = [self showHUDAddedTo:view animated:YES];
    hud.mode = MBProgressHUDModeCustomView;
    hud.customView = customView;
    hud.removeFromSuperViewOnHide = YES;
    hud.bezelView.color = [UIColor clearColor];
    return hud;
}

@end
