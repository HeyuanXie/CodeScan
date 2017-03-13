//
//  UIViewController+Extension.m
//  Base
//
//  Created by admin on 2017/3/2.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIViewController+Extension.h"

@implementation UIViewController (Extension)

- (void)addBackgroundImage:(NSString *)imageName frame:(CGRect)frame {
    UIImageView* imageView = [[UIImageView alloc] initWithImage:ImageNamed(imageName)];
    imageView.frame = frame;
    [self.view addSubview:imageView];
    [self.view sendSubviewToBack:imageView];
}

- (void)addBackgroundImageWithFrame:(CGRect)frame {
    [self addBackgroundImage:@"gradualBackground" frame:frame];
}

- (void)configMessage {
    UIBarButtonItem* message = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"message") style:UIBarButtonItemStylePlain target:self action:@selector(message)];
    self.navigationItem.rightBarButtonItem = message;
}
- (void)message {
    //TODO:进入消息列表
    DLog(@"消息");
}

- (void)addDoubleNavigationItemsWithImages:(NSArray *)imageNames firstBlock:(void (^)())block1 secondBlock:(void (^)())block2 {
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithImage:[ImageNamed(imageNames[0]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:nil];
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc] initWithImage:[ImageNamed(imageNames[1]) imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:nil];
    item1.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        block1();
        return [RACSignal empty];
    }];
    item2.rac_command = [[RACCommand alloc] initWithSignalBlock:^RACSignal *(id input) {
        block2();
        return [RACSignal empty];
    }];
    self.navigationItem.rightBarButtonItems = @[item2, item1];
}

@end
