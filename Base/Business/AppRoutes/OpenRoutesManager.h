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
extern NSString* const kHomeViewController;
extern NSString* const kCollectViewController;
extern NSString* const kOrderHomeController;
extern NSString* const kMineHomeViewController;

extern NSString* const kTheaterListViewController;
extern NSString* const kTheaterDetailViewController;
extern NSString* const kTheaterTicketViewController;
extern NSString* const kFilterTableViewController;
extern NSString* const kCommentViewController;  //添加剧场评论
extern NSString* const kCommentListController;  //指定剧场的用户评论列表
extern NSString* const kTheaterSeatPreviewController;
extern NSString* const kTheaterSeatSelectController;
extern NSString* const kTheaterCommitOrderController;

extern NSString* const kLectureListController;
extern NSString* const kLectureDetailController;
extern NSString* const kLectureApplyController;

extern NSString* const kYearCardHomeController;
extern NSString* const kYearCardBindSuccessController;
extern NSString* const kYearCardOrderController;


extern NSString* const kDeriveListController;
extern NSString* const kDeriveDetailController;
extern NSString* const kDeriveOrderController;
extern NSString* const kDeriveRecordController;


extern NSString* const kOrderListController;
extern NSString* const kOrderDetailController;
extern NSString* const kOrderCodeController;

extern NSString* const kSkillListViewController;
extern NSString* const kSkillDetailController;
extern NSString* const kSkillSituationController;
extern NSString* const kSkillCompetitorController;
extern NSString* const kMineSupportViewController;
extern NSString* const kSkillApplyViewController;
extern NSString* const kSkillUploadViewController;
extern NSString* const kSkillApplySucceedController;

extern NSString* const kVideoListViewController;
extern NSString* const kVideoPlayViewController;

extern NSString* const kWeekEndListController;
extern NSString* const kWeekEndDetailController;

//Mine
extern NSString* const kSettingViewController;
extern NSString* const kMessageHomeController;
extern NSString* const kMessageListController;
extern NSString* const kUserInfoViewController;
extern NSString* const kFeedbackController;
extern NSString* const kAccountSecurityController;

extern NSString* const kMineYearCardController;
extern NSString* const kYearCardDetailController;
extern NSString* const kYearCardRecordController;
extern NSString* const kMineApplyController;
extern NSString* const kPointManageController;
extern NSString* const kPointDetailController;
extern NSString* const kPointDescController;
//extern NSString* const kPointRecordController;    在Derive中定义了
extern NSString* const kMineCouponController;
extern NSString* const kMineCommentController;
//extern NSString* const kMineSupportController;    在Skill中定义了


extern NSString* const kRegistViewController;
extern NSString* const kFinishRegisterController;
extern NSString* const kLoginViewController;
extern NSString* const kChangePasswordController;
extern NSString* const kBindPhoneController;
extern NSString* const kBindPhoneChangeController;


extern NSString* const kSearchGuideController;
extern NSString* const kSearchResultController;
extern NSString* const kFilterClassTableViewController;
extern NSString* const kAddressController;



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
