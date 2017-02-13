//
//  HYCacheURLProtocol.h
//  Base
//
//  Created by admin on 2017/2/8.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>

/** 
    用于缓存webView加载的内容，让webView更native化
 */
@interface HYCacheURLProtocol : NSURLProtocol<NSURLSessionDataDelegate>

@property(nonatomic,strong,readwrite)NSURLSessionConfiguration* config;//config是全局的，所有的网络请求都用这个config
@property(nonatomic,assign,readwrite)NSInteger updateInterval;//相同的url地址请求，相隔大于等于updateInterval才会发出后台更新的网络请求，小于的话不发出请求。

+(void)startListeningNetworking;    //开始监听webView加载的网页，进行数据缓存
+(void)cancelListeningNetworking;   //停止监听，因为config是全局的，不停止的话话监听所有(包括非网页)的数据请求

+(void)setConfig:(NSURLSessionConfiguration*)config;//config是全局的，所有的网络请求都用这个config，参见NSURLSession使用的NSURLSessionConfiguration
+(void)setUpdateInterval:(NSInteger)updateInterval;//相同的url地址请求，相隔大于等于updateInterval才会发出后台更新的网络请求，小于的话不发出请求。默认是3600秒，1个小时

+(void)clearUrlDic;//收到内存警告的时候可以调用这个方法清空内存中的url记录


@end
