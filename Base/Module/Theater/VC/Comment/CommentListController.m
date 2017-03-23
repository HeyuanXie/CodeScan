//
//  CommentListController.m
//  Base
//
//  Created by admin on 2017/3/22.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "CommentListController.h"
#import <UITableView+FDTemplateLayoutCell.h>
#import "CommentListCell.h"
#import "CustomJumpBtns.h"

typedef enum : NSUInteger {
    CommentAll = 0,
    CommentImage,
    CommentNew,
} CommentStyle;

@interface CommentListController ()

@property(strong,nonatomic)NSMutableArray* dataArray;
@property(assign,nonatomic)CommentStyle style;

@end

@implementation CommentListController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.style = CommentAll;
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(42, 0, 0, 0)];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [self.tableView registerNib:[UINib nibWithNibName:[CommentListCell identify] bundle:nil] forCellReuseIdentifier:[CommentListCell identify]];

    [self subviewStyle];
    [self fetchData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.dataArray.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    CommentListCell* cell = [tableView dequeueReusableCellWithIdentifier:[CommentListCell identify]];
    [HYTool configTableViewCellDefault:cell];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    
    [cell configListCell:nil];
    if (indexPath.section%2==0) {
        cell.scrollHeight.constant = 0;
        cell.scrollBottom.constant = 0;
    }else{
        cell.scrollHeight.constant = 106;
        cell.scrollBottom.constant = 14;
    }
    return cell;
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [tableView fd_heightForCellWithIdentifier:[CommentListCell identify] cacheByIndexPath:indexPath configuration:^(CommentListCell* cell) {
        
        [cell configListCell:nil];
        if (indexPath.section%2==0) {
            cell.scrollHeight.constant = 0;
            cell.scrollBottom.constant = 0;
        }else{
            cell.scrollHeight.constant = 106;
            cell.scrollBottom.constant = 14;
        }
    }];
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
}

#pragma mark - private methods
-(NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

-(void)fetchData {
    self.dataArray = [@[@"",@"",@"",@""] mutableCopy];
    DLog("%ld",self.style);
    [self.tableView reloadData];
}

-(void)subviewStyle {
    UIView* topView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 42)];
    topView.backgroundColor = [UIColor whiteColor];
    
    NSArray* titles = @[@"全部",@"晒图",@"最新"];
    CustomJumpBtns* btns = [CustomJumpBtns customBtnsWithFrame:CGRectMake(0, 0, kScreen_Width, 42) menuTitles:titles textColorForNormal:[UIColor hyBlackTextColor] textColorForSelect:[UIColor hyBlueTextColor] isLineAdaptText:YES];
    [topView addSubview:btns];
    NSArray* styles = @[@(CommentAll),@(CommentImage),@(CommentNew)];
    [btns setFinished:^(NSInteger index) {
        //TODO:fetchData
        self.style = [styles[index] integerValue];
        [self fetchData];
    }];
    [self.view addSubview:topView];
}

@end
