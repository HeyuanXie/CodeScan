//
//  DatePickerController.m
//  GreatTigerCustom
//
//  Created by hitao on 16/4/18.
//  Copyright © 2016年 GreatTiger. All rights reserved.
//

#import "DatePickerController.h"

@interface DatePickerController()
@property (nonatomic, strong) UIDatePicker *datePicker;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;

@end

@implementation DatePickerController

- (void)viewDidLoad{
    [super viewDidLoad];
    self.dateFormatter = [[NSDateFormatter alloc] init];// 创建一个日期格式器
    [self.dateFormatter setDateFormat:@"yyyy-MM-dd"];

    self.view.backgroundColor = [UIColor orangeColor];
    
    self.datePicker = [[UIDatePicker alloc]initWithFrame:CGRectMake(0, 80, self.view.frame.size.width, 216)];
    [self.view addSubview:self.datePicker];
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    [self.datePicker autoPinEdgesToSuperviewEdgesWithInsets:UIEdgeInsetsMake(0, 0, 0, 0) excludingEdge:ALEdgeBottom];
    [self.datePicker autoSetDimension:ALDimensionHeight toSize:216];
    self.datePicker.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    [self.datePicker addTarget:self action:@selector(dateChanged:) forControlEvents:UIControlEventValueChanged ];//重点：UIControlEventValueChanged
    
    //设置显示格式
    //默认根据手机本地设置显示为中文还是其他语言
    NSLocale *locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];//设置为中文显示
    self.datePicker.locale = locale;
    
    
    //当前时间创建NSDate
    NSDate *localDate = [NSDate date];
    //设置属性
    self.datePicker.minimumDate = [NSDate dateWithTimeIntervalSinceNow:100*365*24*60*60];
    self.datePicker.maximumDate = localDate;
}

-(void)dateChanged:(id)sender{
    NSDate *pickerDate = [self.datePicker date];
    NSString *dateString = [self.dateFormatter stringFromDate:pickerDate];
    if (self.selectDate) {
        self.selectDate(dateString);
    }
}

@end
