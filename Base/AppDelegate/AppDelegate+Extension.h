//
//  AppDelegate+Extension.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "AppDelegate.h"

@interface AppDelegate (Extension) <UINavigationControllerDelegate>

- (void)configTabbar;

- (void)configUIAppearance;

- (void)verifyLogin;

- (void)configNotification:(NSDictionary*)launchOptions;

@end
