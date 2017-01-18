//
//  QNShareSDKTools.m
//  QooccShow
//
//  Created by xiaoxiaofeng on 14/11/7.
//  Copyright (c) 2014年 Qoocc. All rights reserved.
//

#import "ShareSDKTools.h"
#import <ShareSDKConnector/ShareSDKConnector.h>
#import <ShareSDK/ShareSDK.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>

//腾讯开放平台（对应QQ和QQ空间）SDK头文件
#import <TencentOpenAPI/TencentOAuth.h>
#import <TencentOpenAPI/QQApiInterface.h>

//微信SDK头文件
#import "WXApi.h"

//新浪微博SDK头文件
#import "WeiboSDK.h"

@implementation ShareSDKTools


// 分享链接
+ (void)shareUrl:(NSString *)url image:(UIImage *)image title:(NSString *)title content:(NSString *)content shareType:(NSInteger)shareType callback:(void(^)(BOOL isSuccessed))callback {

    if (!url) {
        NSAssert(NO, @"分享链接的时候，链接居然为空！");
        return;
    }
    
    NSMutableDictionary *params = [NSMutableDictionary dictionary];
    [params SSDKSetupShareParamsByText:content images:image url:[NSURL URLWithString:url] title:title type:SSDKContentTypeAuto];
    switch (shareType) {
        case SSDKPlatformTypeSinaWeibo:{
            [params SSDKSetupSinaWeiboShareParamsByText:[NSString stringWithFormat:@"%@%@", content, url] title:nil image:image url:nil latitude:0 longitude:0 objectID:nil type:SSDKContentTypeWebPage];
        }break;
        case SSDKPlatformTypeTencentWeibo:{
            
        }break;
        case SSDKPlatformSubTypeQZone:{
            
        }break;
        case SSDKPlatformSubTypeWechatSession:{
            [params SSDKSetupWeChatParamsByText:content title:title url:[NSURL URLWithString:url] thumbImage:image image:image musicFileURL:nil extInfo:nil fileData:nil emoticonData:nil type:SSDKContentTypeAuto forPlatformSubType:SSDKPlatformSubTypeWechatSession];// 微信好友子平台
        }break;
        case SSDKPlatformSubTypeWechatTimeline:{
            
        }break;
        case SSDKPlatformSubTypeQQFriend:{
            
        }break;
        default:
            break;
    }
    [params SSDKEnableUseClientShare];
    [ShareSDK share:shareType parameters:params onStateChanged:^(SSDKResponseState state, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error) {
        switch (state) {
            case SSDKResponseStateSuccess:
                callback(YES);  // 分享成功
                break;
            case SSDKResponseStateBegin:
            case SSDKResponseStateCancel:
            case SSDKResponseStateFail:
                callback(NO);
            default:
                break;
        }
    }];


}

/*
+ (void)shareShowActionSheet:(ArticleListModel *)model view:(UIView *)view{
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:APIHELPER.config[@"icon_url"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:model.summary
                                         images:@[image]
                                            url:[NSURL URLWithString:model.detailURL]
                                          title:model.title
                                           type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
                                                                         items:@[@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformTypeSinaWeibo)]
                                                                   shareParams:shareParams
                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                               
                                                               switch (state) {
                                                                   case SSDKResponseStateSuccess:
                                                                   {
                                                                       
                                                                       break;
                                                                   }
                                                                   case SSDKResponseStateFail:
                                                                   {
                                                                       
                                                                       break;
                                                                   }
                                                                   default:
                                                                       break;
                                                               }
                                                           }
                                                 ];
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    }];
    
}

+ (void)shareShowActionSheet:(NSString *)title summary:(NSString *)summary url:(NSString *)urlString view:(UIView *)view{
    UIImageView *imageView = [[UIImageView alloc] init];
    [imageView sd_setImageWithURL:[NSURL URLWithString:APIHELPER.config[@"icon_url"]] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
        
        NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
        [shareParams SSDKSetupShareParamsByText:summary
                                         images:@[image]
                                            url:[NSURL URLWithString:urlString]
                                          title:title
                                           type:SSDKContentTypeAuto];
        
        //2、分享（可以弹出我们的分享菜单和编辑界面）
        SSUIShareActionSheetController *sheet = [ShareSDK showShareActionSheet:view
                                                                         items:@[@(SSDKPlatformSubTypeWechatTimeline),@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeQQFriend),@(SSDKPlatformSubTypeQZone),@(SSDKPlatformTypeSinaWeibo)]
                                                                   shareParams:shareParams
                                                           onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                                                               
                                                               switch (state) {
                                                                   case SSDKResponseStateSuccess:
                                                                   {
                                                                       
                                                                       break;
                                                                   }
                                                                   case SSDKResponseStateFail:
                                                                   {
                                                                       
                                                                       break;
                                                                   }
                                                                   default:
                                                                       break;
                                                               }
                                                           }
                                                 ];
        [sheet.directSharePlatforms addObject:@(SSDKPlatformTypeSinaWeibo)];
    }];
    
}
 */

+ (BOOL)isWXAppInstalled{
    return [WXApi isWXAppInstalled];
}

+ (BOOL)isQQInstalled{
    return [QQApiInterface isQQInstalled];
}

+ (BOOL)isWeiboAppInstalled{
    return [WeiboSDK isWeiboAppInstalled];
}

@end
