//
//  DatePickerView.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "DatePickerView.h"
#import "Marco.h"

@interface DatePickerView ()

@end

@implementation DatePickerView

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    _datePicker.datePickerMode = UIDatePickerModeDateAndTime;
    
    NSDate *now = [NSDate date];
    
    NSTimeInterval time = [now timeIntervalSince1970];
    time += 60;
    
    now = [NSDate dateWithTimeIntervalSince1970:time];
    
    _datePicker.minimumDate = now;

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kDatePickerCanceledNotification object:nil];
}

- (IBAction)completeButtonClicked:(id)sender {
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc]init];
    
    [dateFormatter setDateFormat:@"yyyy年MM月dd日 HH时"];
    
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc]init];
    
    [newDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    _formatterDateStr = [newDateFormatter stringFromDate:_datePicker.date];
    
    NSString *timeStr = [dateFormatter stringFromDate:_datePicker.date];
    
    _dateStr = timeStr;
    
    _date = _datePicker.date;
    
    [[NSNotificationCenter defaultCenter]postNotificationName:kDatePickerCompleteSelectedNotification object:nil];
    
}


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
