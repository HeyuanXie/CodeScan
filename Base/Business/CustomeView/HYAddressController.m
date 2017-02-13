//
//  HYAddressController.m
//  Base
//
//  Created by admin on 2017/2/10.
//  Copyright © 2017年 XHY. All rights reserved.
//

#import "HYAddressController.h"
#import <CoreLocation/CoreLocation.h>

#define kCountryCellIdentify @"CountryCellIdentify"
#define kCountryHeadIdentify @"CountryHeadIdentify"

#define kAllCountryTag @"全国"
#define kLocationCityTag @"当前定位城市"

@interface HYAddressController ()<CLLocationManagerDelegate>

@property(nonatomic,strong)NSArray* addresses;
@property(nonatomic,strong)NSArray* areaKeys;
@property(nonatomic,strong)NSMutableDictionary* areaCodeDict;
@property(nonatomic,strong)NSArray* searchIndexs;
@property(nonatomic,assign,readonly)BOOL showQuickSearch;

@property(nonatomic,strong)CLLocationManager* locationManager;
@property(nonatomic,strong)NSString* areaName;

@property(nonatomic,assign)NSInteger level;     //省、市、区级别

@end

@implementation HYAddressController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self filterInit];
    [self tableViewStyle];
    [self dataInit];
    [self findCurrentLocation];
}

-(BOOL)showQuickSearch {
    if (self.addresses.count > 0) {
        NSDictionary* dict = self.addresses.lastObject;
        return [dict.allKeys containsObject:@"p"];
    }
    return NO;
}

-(void)filterInit {
    switch (self.level) {
        case 0:
            self.navigationItem.title = @"请选择省份";
            break;
        case 1:
            self.navigationItem.title = @"请选择城市";
            break;
        case 2:
            self.navigationItem.title = @"请选择镇/县";
            break;
        default:
            break;
    }
    
    if (_isFilter) {
        UIButton* closeButton = [UIButton buttonWithType:UIButtonTypeCustom];
        closeButton.frame = CGRectMake(0, 0, 44, 44);
        closeButton.titleLabel.font = defaultSysFontWithSize(14);
        [closeButton addTarget:self action:@selector(dismissAddress) forControlEvents:UIControlEventTouchUpInside];
        [closeButton setTitle:@"关闭" forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor hyBarTintColor] forState:UIControlStateNormal];
        [closeButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    }
    
    if (_level != 0) {
        UIButton* backButton = [UIButton buttonWithType:UIButtonTypeCustom];
        backButton.titleLabel.font = defaultSysFontWithSize(14);
        [backButton addTarget:self action:@selector(backAction) forControlEvents:UIControlEventTouchUpInside];
        [backButton setTitle:@"返回" forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor hyBarTintColor] forState:UIControlStateNormal];
        [backButton setTitleColor:[UIColor grayColor] forState:UIControlStateHighlighted];
        self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:backButton];
    }
}

-(void)dismissAddress {
    if (self.filterDismiss) {
        self.filterDismiss();
    }
}

- (void)findCurrentLocation {
    if (![CLLocationManager locationServicesEnabled]) {
        self.areaCodeDict[kLocationCityTag] = @[@{@"k":@(-1),@"n":@"请开启定位权限"}];
    }
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;
    self.locationManager.desiredAccuracy = kCLLocationAccuracyBest;
    self.locationManager.distanceFilter = 10;
    [self.locationManager requestWhenInUseAuthorization];
    [self.locationManager startUpdatingLocation];//开启定位
}

- (void)loadCoord:(CLLocationCoordinate2D)coord finish:(void(^)(NSString *address))finish{
    CLGeocodeCompletionHandler handler = ^(NSArray *place, NSError *error){
        for (CLPlacemark *placemark in place){
            finish(placemark.locality);
            break;
        }
    };
    CLGeocoder *Geocoder=[[CLGeocoder alloc]init];
    CLLocation *loc = [[CLLocation alloc] initWithLatitude:coord.latitude longitude:coord.longitude];
    [Geocoder reverseGeocodeLocation:loc completionHandler:handler];
}

-(void)tableViewStyle {
    
    [self baseSetupTableView:UITableViewStylePlain InSets:UIEdgeInsetsZero];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    //设置索引的颜色
    self.tableView.sectionIndexColor = [UIColor hyBarTintColor];
    //设置索引选中的颜色
    self.tableView.sectionIndexTrackingBackgroundColor = [UIColor hySeparatorColor];
    
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCountryCellIdentify];
    [self.tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:kCountryHeadIdentify];
    
}

-(void)dataInit {
    if (!self.addresses) {
        NSData* areaCodeData = [NSData dataWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"area.json" ofType:nil]];
        self.addresses = [NSJSONSerialization JSONObjectWithData:areaCodeData options:NSJSONReadingAllowFragments error:nil];
    }
    self.showAllCountry = YES;
    if (self.showQuickSearch) {
        NSMutableDictionary* keyCodes = [NSMutableDictionary dictionaryWithCapacity:self.addresses.count];
        for (NSDictionary* dict in self.addresses) {
            NSString* key = dict[@"p"];
            NSMutableArray* array = keyCodes[key];
            if (!array) {
                array = [NSMutableArray array];
                keyCodes[key] = array;
            }
            [array addObject:dict];
        }
        NSArray* keys = [keyCodes.allKeys sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            return [obj1 compare:obj2];
        }];
        self.searchIndexs = [NSArray arrayWithArray:keys];
        
        NSMutableArray* mKeys = [NSMutableArray arrayWithArray:keys];
        [mKeys insertObject:kLocationCityTag atIndex:0];
        if (self.showAllCountry) {
            [mKeys insertObject:kAllCountryTag atIndex:0];
        }
        self.areaKeys = [NSArray arrayWithArray:mKeys];
        
        keyCodes[kAllCountryTag] = @[@{@"k":@(0),@"n":@"全国"}];
        keyCodes[kLocationCityTag] = @[@{@"k":@(-1),@"n":@"定位中..."}];
        self.areaCodeDict = keyCodes;
    }else{
        self.areaKeys = @[kAllCountryTag];
        self.areaCodeDict = [NSMutableDictionary dictionaryWithDictionary:@{kAllCountryTag:self.addresses}];
    }
}



#pragma mark tableview source
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSString *key = self.areaKeys[section];
    NSArray *contrys = self.areaCodeDict[key];
    return contrys.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCountryCellIdentify];
    NSString *key = self.areaKeys[indexPath.section];
    NSArray *contrys = self.areaCodeDict[key];
    NSDictionary *dict = contrys[indexPath.row];
    cell.textLabel.text = dict[@"n"];
    if (dict[@"k"] && ([dict[@"k"] integerValue] == -1)) {
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }else{
        cell.selectionStyle = UITableViewCellSelectionStyleDefault;
    }
    cell.textLabel.font = [UIFont systemFontOfSize:14.0];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.areaKeys.count;
}

- (nullable UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    if (!self.showQuickSearch) {
        return nil;
    }
    if ([self.areaKeys[section] isEqualToString:kAllCountryTag]) {
        return nil;
    }
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:kCountryHeadIdentify];
    NSString *key = self.areaKeys[section];
    cell.textLabel.text = key;
    cell.textLabel.font = [UIFont systemFontOfSize:13.0];
    cell.contentView.backgroundColor = [UIColor whiteColor];
    return cell;
}

- (nullable NSArray<NSString *> *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    if (!self.showQuickSearch) {
        return nil;
    }
    return self.searchIndexs;
}

- (NSInteger)tableView:(UITableView *)tableView sectionForSectionIndexTitle:(NSString *)title atIndex:(NSInteger)index{
    NSInteger section = index + 1 + (self.showAllCountry?1:0);
    [tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:section] atScrollPosition:UITableViewScrollPositionTop animated:YES];
    return index;
}

#pragma mark tableview delegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 44.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (!self.showQuickSearch) {
        return CGFLOAT_MIN;
    }
    if ([self.areaKeys[section] isEqualToString:kAllCountryTag]) {
        return CGFLOAT_MIN;
    }
    return 30.0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    if (!self.showQuickSearch) {
        return CGFLOAT_MIN;
    }
    if (section == (self.areaKeys.count - 1)) {
        return CGFLOAT_MIN;
    }
    return 8.0;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    NSString *key = self.areaKeys[indexPath.section];
    NSArray *contrys = self.areaCodeDict[key];
    NSDictionary *dict = contrys[indexPath.row];
    NSArray *array = dict[@"c"];
    if (array.count > 0) {
        HYAddressController *addressC = (HYAddressController *)VIEWCONTROLLER(kAddressController);
        if (!self.areaName) {
            self.areaName = @"";
        }
        addressC.areaName = [NSString stringWithFormat:@"%@%@", self.areaName, dict[@"n"]];
        addressC.selectAddress = self.selectAddress;
        addressC.addresses = array;
        addressC.level = self.level+1;
        addressC.isFilter = self.isFilter;
        [self.navigationController pushViewController:addressC animated:YES];
    }else{
        if (self.showQuickSearch) {
            if ([key isEqualToString:kAllCountryTag]) {
                if (self.selectAddress) {
                    self.selectAddress(@"", @"");
                }
            }else if ([key isEqualToString:kLocationCityTag]){
                if ([dict[@"k"] integerValue] == 0) {
                    if (self.selectAddress) {
                        self.selectAddress(dict[@"n"], @"");
                    }
                }else{
                    return;
                }
            }
        }
        if (self.selectAddress) {
            if (!self.areaName) {
                self.areaName = @"";
            }
            self.selectAddress([NSString stringWithFormat:@"%@%@", self.areaName, dict[@"n"]], [NSString stringWithFormat:@"%@", dict[@"k"]]);
        }
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}

#pragma mark CLLocationManagerDelegate
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray<CLLocation *> *)locations {
    // 5
    CLLocation *currentLocation = [locations lastObject];
    
    @weakify(self);
    [self loadCoord:currentLocation.coordinate finish:^(NSString *address) {
        @strongify(self);
        self.areaCodeDict[@"当前定位城市"] = @[@{@"k":@(0),@"n":address}];
        [self.tableView reloadData];
    }];
    [self.locationManager stopUpdatingLocation];
}

-(void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error{
    if ([error code]==kCLErrorDenied) {
        NSLog(@"访问被拒绝");
    }
    if ([error code]==kCLErrorLocationUnknown) {
        NSLog(@"无法获取位置信息");
    }
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
