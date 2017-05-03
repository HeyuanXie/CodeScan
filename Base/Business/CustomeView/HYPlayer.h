//
//  HYPlayer.h
//  Base
//
//  Created by admin on 2017/5/3.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <AVKit/AVKit.h>

@interface HYPlayer : AVPlayerViewController


/**
 是否自动播放,默认为YES
 */
@property(nonatomic,assign)BOOL autoPlay;



/**
 播放网络音频或视频

 @param urlStr 网络音频或视频url
 @return <#return value description#>
 */
-(HYPlayer*)initWithUrlStr:(NSString*)urlStr;



/**
 播放本地音频或视频

 @param fileName 本地音频或视频文件名称
 @param fileType 文件类型(mp3、mp4)
 @return <#return value description#>
 */
-(HYPlayer*)initWithName:(NSString*)fileName type:(NSString*)fileType;

@end
