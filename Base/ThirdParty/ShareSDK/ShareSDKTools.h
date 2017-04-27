//
//
//
//
//  Created by  on 14/11/7.
//  Copyright (c) 2014年 . All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ShareSDK/ShareSDK.h>
@class ArticleModel;

@interface ShareSDKTools : NSObject


/**
 *  分享链接
 *
 *  @param url       分享链接 （必须要有）
 *  @param image     分享的image
 *  @param title     分享标题
 *  @param content   分享描述
 *  @param shareType 分享类型
 *  @param callback  分享回调
 */
+ (void)shareUrl:(NSString *)url image:(UIImage *)image title:(NSString *)title content:(NSString *)content shareType:(NSInteger)shareType callback:(void(^)(BOOL isSuccessed))callback;

+ (void)shareShowActionSheet:(ArticleModel *)model view:(UIView *)view;

+ (void)shareShowActionSheet:(NSString *)title summary:(NSString *)summary url:(NSString *)urlString imgUrl:(NSString*)imgUrl view:(UIView *)view;

+ (BOOL)isWXAppInstalled;

+ (BOOL)isQQInstalled;

+ (BOOL)isWeiboAppInstalled;

@end
