//
//  ScanResultContoller.h
//  Base
//
//  Created by admin on 2017/5/9.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "BaseTableViewController.h"

@protocol ScanResultDelegate <NSObject>

- (void)actionSucceedAfterScan;

@end

@interface ScanResultContoller : BaseTableViewController

/**
 是否有没有使用的票
 */
@property(nonatomic,assign)BOOL haveTicketAvilable;
@property(nonatomic,assign)NSInteger orderType;
@property(nonatomic,strong)NSDictionary *data;
@property(nonatomic,strong)NSArray *tickets;

@property(nonatomic,strong)id<ScanResultDelegate>delegate;

@end
