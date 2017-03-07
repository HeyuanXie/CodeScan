//
//  TheaterDetailViewController.m
//  Base
//
//  Created by admin on 2017/3/6.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "TheaterDetailViewController.h"
#import "TheaterDetailCell.h"
#import "NSString+Extension.h"
#import "DetailDervieView.h"

@interface TheaterDetailViewController ()

@property(nonatomic,strong)NSArray* titles;
@property(nonatomic,assign)NSInteger cellAddHeight;
@property(nonatomic,assign)NSInteger botViewAddHeight;
@property(nonatomic,assign)NSInteger unfoldHeight;
@property(nonatomic,assign)BOOL isFold;

@end

@implementation TheaterDetailViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationBarTransparent = YES;
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsMake(-64, 0, 60, 0)];
    [self.tableView registerNib:[UINib nibWithNibName:[TheaterDetailCell identify] bundle:nil] forCellReuseIdentifier:[TheaterDetailCell identify]];
    
    [self dataInit];
    [self subviewInit];
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - tableView dataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.titles.count;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 1;
}
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return [self topCellForTableView:tableView indexPath:indexPath];
        case 1:
            return [self aroundCellForTableView:tableView indexPath:indexPath];
        case 2:
            return [self commentCellForTableView:tableView indexPath:indexPath];
        default:
            return [self recommendCellForTableView:tableView indexPath:indexPath];
    }
}
//MARK:the cells
-(TheaterDetailCell*)topCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    TheaterDetailCell* cell = [tableView dequeueReusableCellWithIdentifier:[TheaterDetailCell identify]];
    if (self.unfoldHeight < 397) {
        cell.unfoldBtnHeight.constant = 0;
    }
    [cell setUnfoldBtnClick:^{
        self.isFold = !self.isFold;
        [self.tableView reloadData];
    }];
    [cell configTopCell:nil];
    return cell;
}
-(UITableViewCell*)aroundCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"aroundCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        UIScrollView* scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, 138)];
        scrollView.showsVerticalScrollIndicator = NO;
        scrollView.showsHorizontalScrollIndicator = NO;
        scrollView.delegate = self;
        scrollView.tag = 1000;
        [cell.contentView addSubview:scrollView];
    }
    UIScrollView* scrollView = (UIScrollView*)[cell.contentView viewWithTag:1000];
    for (int i = 0; i<7; i++) {
        DetailDervieView* view = (DetailDervieView*)[[NSBundle mainBundle] loadNibNamed:@"TheaterUseView" owner:self options:nil][0];
        view.frame = CGRectMake(106*i+10, 0, 106, 138);
        [scrollView addSubview:view];
    }
    scrollView.contentSize = CGSizeMake(10+106*7, 0);
    return cell;
}

-(UITableViewCell*)commentCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"commentCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}
-(UITableViewCell*)recommendCellForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath {
    static NSString* cellId = @"recommendCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    return cell;
}
#pragma mark - tableView delegate
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.section) {
        case 0:
            return self.isFold ? self.unfoldHeight : MIN(397, self.unfoldHeight);
        case 1:
            return 138;
        case 2:
            return 245;
        default:
            return 222;
    }
}

#pragma mark - actions
- (IBAction)buyTicket:(id)sender {
    
}

#pragma mark - private methods
-(void)dataInit {
    self.titles = @[@"",@"戏剧周边",@"观众点评",@"演出推荐"];
    
//    [APIHELPER ]
//    NSString* desc = [model.description size。。。]
    NSString* desc = @"阿萨德法师法师法师打发的方式是打发发生的发生发大水法法师打发斯蒂芬阿萨德法师法师法师打发的方式是打发发生的发生发大水法法师打发斯蒂芬阿萨德法师法师法师打发的方式是打发发生的发生发大水法法师打发斯蒂芬大水法法师打发斯蒂芬阿萨德法师法师法师打发的方式是打发发生的发生发大水法法师打发斯蒂芬";
    self.botViewAddHeight = ([desc sizeWithFont:[UIFont systemFontOfSize:20] maxWidth:kScreen_Width-48].height - 95);
    self.cellAddHeight = ([desc sizeWithFont:[UIFont systemFontOfSize:14] maxWidth:kScreen_Width-46].height - 95);
    self.unfoldHeight = 397 + _cellAddHeight;
}

-(void)subviewInit {
    self.title = @"丑小鸭";
    
    UIBarButtonItem* item1 = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"cart") style:UIBarButtonItemStyleDone target:self action:@selector(collect)];
    UIBarButtonItem* item2 = [[UIBarButtonItem alloc] initWithImage:ImageNamed(@"") style:UIBarButtonItemStyleDone target:self action:@selector(share)];
    self.navigationController.navigationItem.rightBarButtonItems = @[item1,item2];
}
-(void)collect {
    
}
-(void)share {
    
}


@end
