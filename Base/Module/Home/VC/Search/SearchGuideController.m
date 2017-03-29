//
//  SearchGuideController.m
//  Base
//
//  Created by admin on 2017/3/23.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "SearchGuideController.h"
#import "UITableViewCell+HYCell.h"
#import "SearchGuideCell.h"
#import "FTPopOverMenu.h"
#import <FMDB.h>

@interface SearchGuideController ()<UITextFieldDelegate>

@property(strong,nonatomic)NSMutableArray* interested;
@property(strong,nonatomic)NSMutableArray* history;

@property(strong,nonatomic)UITextField* textField;
@property(assign,nonatomic)NSInteger contentType;

@end

@implementation SearchGuideController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.contentType = 2;   //默认为文章
    if (self.schemaArgu[@"contentType"]) {
        self.contentType = [[self.schemaArgu objectForKey:@"contentType"] integerValue];
    }
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(0, 0, 0, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[SearchGuideCell identify] bundle:nil] forCellReuseIdentifier:[SearchGuideCell identify]];

    [self subviewStyle];
    [self fetchData];
}

- (void)viewWillAppear:(BOOL)animated {
    
    [super viewWillAppear:YES];
    [self queryValueFromDB:[self createOrOpenDB]];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - talbeView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return section == 0 ? 3 : (self.history.count == 0 ? 0 : self.history.count+1);
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            if (indexPath.row==1) {
                static NSString* cellId = @"btnsCell";
                UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
                if (cell == nil) {
                    cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
                    [HYTool configTableViewCellDefault:cell];
                    cell.contentView.backgroundColor = [UIColor whiteColor];
                }
                for (UIView* subview in cell.contentView.subviews) {
                    [subview removeFromSuperview];
                }
                CGFloat width = (kScreen_Width-4*12)/3,x = 12,y = 12;
                for (int i=0; i<self.interested.count; i++) {
                    if (i%3==0 && i!=0) {
                        y = y + 26+12;
                    }
                    UIButton* btn = [HYTool getButtonWithFrame:CGRectMake(x+(x+width)*(i%3), y, width, 26) title:self.interested[i] titleSize:14 titleColor:[UIColor hyBlackTextColor] backgroundColor:nil blockForClick:^(id sender) {
                        
                    }];
                    [HYTool configViewLayer:btn withColor:[UIColor hySeparatorColor]];
                    [HYTool configViewLayerRound:btn];
                    [cell.contentView addSubview:btn];
                }
                return cell;
            }else{
                SearchGuideCell* cell = [tableView dequeueReusableCellWithIdentifier:[SearchGuideCell identify]];
                [cell configGuideHeadCell];
                cell.titleLbl.text = indexPath.row == 0 ? @"你可能感兴趣" : @"搜索历史";
                return cell;
            }
        default:
        {
            if (indexPath.row == self.history.count) {
                
                SearchGuideCell* cell = [tableView dequeueReusableCellWithIdentifier:[SearchGuideCell identify]];
                [cell configGuideClearAllCell];
                [cell.closeAllBtn bk_whenTapped:^{
                    //清除所有记录
                    [self deleteAllValueFromDB:[self createOrOpenDB]];
                    [self queryValueFromDB:[self createOrOpenDB]];
                }];
                return cell;
            }else{
                
                SearchGuideCell* cell = [tableView dequeueReusableCellWithIdentifier:[SearchGuideCell identify]];
                [cell configGuideHistoryCell:nil];
                cell.titleLbl.text = self.history[indexPath.row];
                [cell.closeView bk_whenTapped:^{
                    //清除本条记录
                    [self deleteValueFromDB:[self createOrOpenDB] text:cell.titleLbl.text];
                    [self queryValueFromDB:[self createOrOpenDB]];
                }];
                [cell addLine:NO leftOffSet:12 rightOffSet:0];
                return cell;
            }
        }
    }
}

#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.section == 1) {
        return 46;
    }
    
    NSInteger row = self.interested.count / 3 + (self.interested.count % 3 == 0 ? 0 : 1);
    return indexPath.row == 1 ? 26*row + 12*(row+1) : 46;
}
-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    switch (indexPath.section) {
        case 0:
            return;
        default:
            if (indexPath.row != self.history.count) {
                APPROUTE(([NSString stringWithFormat:@"%@?word=%@",kSearchResultController,self.history[indexPath.row]]));
            }
    }
}


#pragma mark - textField delegate
-(BOOL)textFieldShouldReturn:(UITextField *)textField {
    if ([textField.text isEmpty]) {
        [self showMessage:@"请输入关键词"];
        return NO;
    }
    [self insertValueToDB:[self createOrOpenDB] text:textField.text];
    [textField resignFirstResponder];
    APPROUTE(([NSString stringWithFormat:@"%@?word=%@&type=%ld",kSearchResultController,textField.text,self.contentType]));
    return YES;
}

#pragma mark - private methods
-(NSMutableArray *)interested {
    if (!_interested) {
        _interested = [NSMutableArray array];
    }
    return _interested;
}

-(NSMutableArray *)history {
    if (!_history) {
        _history = [NSMutableArray array];
    }
    return _history;
}

-(void)fetchData {
    
    self.interested = [@[@"辣鸡好辣",@"阿斯蒂芬",@"阿斯蒂芬",@"围绕发啊啊"] mutableCopy];
    [self.tableView reloadData];
}

-(void)subviewStyle {
    
    UIView* searhView = LOADNIB(@"HomeUseView", 3);
    searhView.frame = CGRectMake(0, 0, kScreen_Width-80, 34);
    [HYTool configViewLayer:searhView];
    
    NSArray* menu = @[@"演出",@"商品",@"文章"];
    UIButton* btn = [searhView viewWithTag:1000];
    [btn setTitle:menu[self.contentType] forState:UIControlStateNormal];
    btn.imageEdgeInsets = UIEdgeInsetsMake(0, 30, 0, -30);
    btn.titleEdgeInsets = UIEdgeInsetsMake(0, -12, 0, 12);
    [btn bk_whenTapped:^{
        [btn setImage:ImageNamed(@"三角形_黑色上") forState:UIControlStateNormal];
        [[FTPopOverMenuConfiguration defaultConfiguration] setMenuWidth:100];
        [[FTPopOverMenuConfiguration defaultConfiguration] setMenuTextMargin:12];
        [[FTPopOverMenuConfiguration defaultConfiguration] setMenuIconMargin:12];
        [FTPopOverMenu showForSender:btn withMenuArray:menu imageArray:@[@"搜索类别_演出",@"搜索类别_商品",@"搜索类别_文章"] doneBlock:^(NSInteger selectedIndex) {
            [btn setTitle:menu[selectedIndex] forState:UIControlStateNormal];
            [btn setImage:ImageNamed(@"三角形_黑色下") forState:UIControlStateNormal];
            self.contentType = selectedIndex;
        } dismissBlock:^{
            [btn setImage:ImageNamed(@"三角形_黑色下") forState:UIControlStateNormal];
        }];
    }];
    
    UITextField* textField = [searhView viewWithTag:1001];
    textField.returnKeyType = UIReturnKeySearch;
    self.textField = textField;
    self.textField.delegate = self;
    self.textField.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.textField.tintColor = RGB(0, 122, 255, 1);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:searhView];
    
    UIBarButtonItem* rightItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    rightItem.tintColor = [UIColor whiteColor];
    [rightItem setTitleTextAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:15]} forState:UIControlStateNormal];
    self.navigationItem.rightBarButtonItem = rightItem;
}

-(void)cancel {
    [self.navigationController popViewControllerAnimated:YES];
}

//MARK: dataBase
-(FMDatabase*)createOrOpenDB {
    NSString *path = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,NSUserDomainMask,YES).firstObject;
    NSString *filePath = [path stringByAppendingPathComponent:@"FMDB.db"];
    FMDatabase *database = [FMDatabase databaseWithPath:filePath];
    if (![database open]) {
        return database;
        DLog(@"不能打开数据库");
    }
    if ([database executeUpdate:@"CREATE TABLE IF NOT EXISTS searchHistory (id integer PRIMARY KEY AUTOINCREMENT, keyword text NOT NULL);"]) {

    }else{
        DLog(@"创建表失败");
    }
    return database;
}

-(void)insertValueToDB:(FMDatabase*)database text:(NSString*)text {
    
    for (NSString* tmp in self.history) {
        if ([tmp isEqualToString:text]) {
            return;
        }
    }
    if ([database executeUpdate:@"INSERT INTO searchHistory (keyword) VALUES (?);",text]) {
        
    }else{
        DLog(@"插入数据失败");
    }
    [database close];
}

-(void)deleteValueFromDB:(FMDatabase*)database text:(NSString*)text {
    
    if ([database executeUpdate:@"delete from searchHistory where (keyword) = (?)",text]) {
        
    }else{
        DLog(@"删除数据失败");
    }
    [database close];
}

-(void)deleteAllValueFromDB:(FMDatabase*)database {
    if (![[self createOrOpenDB] executeUpdate:@"DELETE FROM searchHistory"]) {
        DLog(@"删除所有记录失败");
    };
    [database close];
}

-(void)queryValueFromDB:(FMDatabase*)database {
    [self.history removeAllObjects];
    FMResultSet *resultSet = [database executeQuery:@"SELECT * FROM searchHistory"];
    
    // 2.遍历结果
    while ([resultSet next]) {
        NSString* keyword = [resultSet stringForColumn:@"keyword"];
        [self.history addObject:keyword];
    }
    [self.tableView reloadData];
    [database close];
}

@end
