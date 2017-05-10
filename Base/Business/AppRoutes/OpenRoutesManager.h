//
//  OpenRoutesManager.h
//  Base
//
//  Created by admin on 17/1/16.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
// vc标识

extern NSString* const kLoginViewController;
extern NSString* const kCodeScanController;
extern NSString* const kCodeInputController;
extern NSString* const kScanResultController;




#define APPROUTE(storyboardID) [[OpenRoutesManager shareInstance] routeByStoryboardID:(storyboardID)];
#define VIEWCONTROLLER(storyboardID) [[OpenRoutesManager shareInstance] viewControllerForStoryboardID:storyboardID];
#define ROUTER ([OpenRoutesManager shareInstance])

@interface OpenRoutesManager : NSObject

+(id)shareInstance;

-(void)registSchema;
-(void)routeSchemaByURL:(NSURL*)url;
-(void)routeSchemaByString:(NSString*)urlstr;
-(void)routeByStoryboardID:(NSString*)sid;    //如果需要传参数(单个参数) 则: storyboardID?user_id=2&sex=1
-(void)routeByStoryboardID:(NSString*)sid withParam:(NSDictionary*)param; //如果需要传参数(字典) 则: storyboardID?  param = @{@"user_id":@"2",@"sex":@(1)};
-(UIViewController*)viewControllerForStoryboardID:(NSString*)storyboardID;

@end
