//
//  UIViewController+Extension.m
//  Base
//
//  Created by admin on 2017/3/2.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "UIViewController+Extension.h"
#import <CoreLocation/CoreLocation.h>
#import <MapKit/MapKit.h>

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
    //TODO:进入消息页面
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


/**
 弹出actionSheet选择已安装地图导航

 @param addressString 目的地址
 */
- (void)geocoderClick:(NSString *)addressString{
    
    // 创建Geocoder
    CLGeocoder *geocoder = [CLGeocoder new];
    
    // 调用方法
    [geocoder geocodeAddressString:addressString completionHandler:^(NSArray* _Nullable placemarks, NSError * _Nullable error) {
        
        if (placemarks.count == 0 || error) {
            
            [MBProgressHUD hy_showMessage:@"目的地地址有误，请打开地图导航" inView:self.view];
            return;
        }
        
        CLPlacemark *pm = [placemarks lastObject];
        CLLocationCoordinate2D gps = CLLocationCoordinate2DMake(pm.location.coordinate.latitude, pm.location.coordinate.longitude);
        NSArray *maps = [self getInstalledMapAppWithAddr:addressString withEndLocation:gps];
        [self alertAmaps:gps maps:maps];
    }];
    
}

- (NSArray *)getInstalledMapAppWithAddr:(NSString *)addrString withEndLocation:(CLLocationCoordinate2D)endLocation {
    
    NSMutableArray *maps = [NSMutableArray array];
    //苹果地图
    NSMutableDictionary *iosMapDic = [NSMutableDictionary dictionary];
    iosMapDic[@"title"] = @"苹果地图";
    [maps addObject:iosMapDic];
    NSString *appStr = NSLocalizedString(@"app_name", nil);
    
    //高德地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"iosamap://"]]) {
        NSMutableDictionary *gaodeMapDic = [NSMutableDictionary dictionary];
        gaodeMapDic[@"title"] = @"高德地图";
        NSString *urlString = [[NSString stringWithFormat:@"iosamap://path?sourceApplication=%@&sid=BGVIS1&did=BGVIS2&dname=%@&dev=0&t=2",appStr ,addrString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
        gaodeMapDic[@"url"] = urlString;
        [maps addObject:gaodeMapDic];
    }
    
    //百度地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"baidumap://"]]) {
        NSMutableDictionary *baiduMapDic = [NSMutableDictionary dictionary];
        baiduMapDic[@"title"] = @"百度地图";
        NSString *urlString = [[NSString stringWithFormat:@"baidumap://map/direction?origin=我的位置&destination=%@&mode=walking&src=%@",addrString ,appStr] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
        baiduMapDic[@"url"] = urlString;
        [maps addObject:baiduMapDic];
    }
    
    //腾讯地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"qqmap://"]]) {
        NSMutableDictionary *qqMapDic = [NSMutableDictionary dictionary];
        qqMapDic[@"title"] = @"腾讯地图";
        NSString *urlString = [[NSString stringWithFormat:@"qqmap://map/routeplan?from=我的位置&type=walk&tocoord=%f,%f&to=%@&coord_type=1&policy=0",endLocation.latitude , endLocation.longitude ,addrString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
        qqMapDic[@"url"] = urlString;
        [maps addObject:qqMapDic];
    }
    
    //谷歌地图
    if ([[UIApplication sharedApplication] canOpenURL:[NSURL URLWithString:@"comgooglemaps://"]]) {
        NSMutableDictionary *googleMapDic = [NSMutableDictionary dictionary];
        googleMapDic[@"title"] = @"谷歌地图";
        NSString *urlString = [[NSString stringWithFormat:@"comgooglemaps://?saddr=&daddr=%@&directionsmode=walking",addrString] stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet  URLQueryAllowedCharacterSet]];
        googleMapDic[@"url"] = urlString;
        [maps addObject:googleMapDic];
    }
    
    return maps;
    
}
//弹出actionSheet提示用户所能打开的第三方地图应用
- (void)alertAmaps:(CLLocationCoordinate2D)gps maps:(NSArray*)maps {
    if (maps.count == 0) {
        return;
    }
    
    UIAlertController *alertVC = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    
    for (int i = 0; i < maps.count; i++) {
        if (i == 0) {
            [alertVC addAction:[UIAlertAction actionWithTitle:maps[i][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self navAppleMap:gps];
            }]];
        }else{
            
            [alertVC addAction:[UIAlertAction actionWithTitle:maps[i][@"title"] style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                
                [self otherMap:i maps:maps];
            }]];
        }
    }
    
    [alertVC addAction:[UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertVC animated:YES completion:nil];
}

//点击actionSheet打开苹果地图
- (void)navAppleMap:(CLLocationCoordinate2D)gps {
    
    MKMapItem *currentLoc = [MKMapItem mapItemForCurrentLocation];
    MKMapItem *toLocation = [[MKMapItem alloc] initWithPlacemark:[[MKPlacemark alloc] initWithCoordinate:gps addressDictionary:nil]];
    NSArray *items = @[currentLoc,toLocation];
    NSDictionary *dic = @{
                          
                          MKLaunchOptionsDirectionsModeKey: MKLaunchOptionsDirectionsModeWalking,
                          
                          MKLaunchOptionsMapTypeKey: @(MKMapTypeStandard),
                          
                          MKLaunchOptionsShowsTrafficKey: @(YES)
                          
                          };
    
    [MKMapItem openMapsWithItems:items launchOptions:dic];
}

//点击actionSheet打开第三方地图
- (void)otherMap:(NSInteger)index maps:(NSArray*)maps {
    
    NSDictionary *dic = maps[index];
    NSString *urlString = dic[@"url"];
    [[UIApplication sharedApplication] openURL:[NSURL URLWithString:urlString]];
}


@end
