//
//  UserInfoModel.h
//  Base
//
//  Created by admin on 2017/3/2.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseModel.h"

@interface UserInfoModel : BaseModel

@property(nonatomic, strong) NSString *userID;
@property(nonatomic, strong) NSString *account;
@property(nonatomic, strong) NSString *filename;
@property(nonatomic, strong) NSString *faceUrl;
@property(nonatomic, strong) NSString *nickName;
@property(nonatomic, assign) NSInteger sex;
@property(nonatomic, strong) NSString *birthday;
@property(nonatomic, strong) NSString *phone;
@property(nonatomic, strong) NSString *areaId;
@property(nonatomic, strong) NSString *areaName;

@end
