//
//  CPSSetCloseBusinessViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/5.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CPSSetCloseBusinessViewController.h"
//#import "DatePickerView.h"
#import "GetMerchantInfoDTO.h"
#import "UIColor+UIColor.h"
@implementation CPSSetCloseBusinessViewController{
    NSInteger editTextFieldTag;
    NSDateFormatter *dateFormatter;
    
    // !开始时间
    NSDate *beginDate;
    // !结束时间
    NSDate *endDate;
    
}

- (void)viewDidLoad{
    
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [self customBackBarButton];
    
    // !改变确定按钮的状态和颜色
    [self changeSureBtnStatue];
    
    
}



- (void)viewWillAppear:(BOOL)animated{
    
    GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    
    NSDate *defStartDate = [dateFormatter dateFromString:getMerchantInfoDTO.closeStartTime];
    NSDate *defEndDate = [dateFormatter dateFromString:getMerchantInfoDTO.closeEndTime];
    
    
//    if (defStartDate) {
//        _startTimeT.text =[NSString stringWithFormat:@"  %@",[self dateFromString:defStartDate withFormat:@"yyyy年 MM月 dd日 HH时"]];
//    }
    
    _startFormatterString = [dateFormatter stringFromDate:defStartDate];
    
//    if (defEndDate) {
//        _endTimeT.text = [NSString stringWithFormat:@"  %@",[self dateFromString:defEndDate withFormat:@"yyyy年 MM月 dd日 HH时"]];
//    }
    
    _endFormatterString = [dateFormatter stringFromDate:defEndDate];
    
    
    [self initTextField];
    
    
}

#pragma mark 请求商家数据 修改本地dto商家数据
//数据初始化
- (void)getMerchantInfo{
    
    [HttpManager sendHttpRequestForGetMerchantInfo: ^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        
        if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
            
            if ([[dic objectForKey:@"data"] isKindOfClass:[NSDictionary class]])
            {
                GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
                [getMerchantInfoDTO setDictFrom:[dic objectForKey:@"data"]];
            }
            
        }else{
            
        }
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
      
        
    } ];
    
}

#pragma mark - Private Functions
//TextField边框颜色初始化
- (void)initTextField{
    
    _startTimeT.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1]CGColor];
    _startTimeT.layer.borderWidth = 1.5;
    
    _endTimeT.layer.borderColor = [[UIColor colorWithWhite:0.9 alpha:1]CGColor];
    _endTimeT.layer.borderWidth = 1.5;
    
    WMCustomDatePicker *WMDatePickerView = [[WMCustomDatePicker alloc]initWithframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) Delegate:self PickerStyle:WMDateStyle_YearMonthDayHour];
    WMDatePickerView.minLimitDate = [NSDate date];


    WMDatePickerView.maxLimitDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30*12];
    WMDatePickerView.hasToolbar = YES;
    WMDatePickerView.delegate = self;

    _startTimeT.inputView = WMDatePickerView;
    _endTimeT.inputView = WMDatePickerView;
    
    
}
#pragma mark 歇业请求
- (IBAction)comfirmButtonClicked:(id)sender {
    
    [self.view endEditing:YES];
    
    // !判断选定的时间是否符合要求
    if ([self sureTime]) {
        
        self.sureBtn.enabled = NO;
        
        [HttpManager sendHttpRequestForGetUpdateMerchantBusiness:@"1" closeStartTime:_startFormatterString closeEndTime:_endFormatterString success:^(AFHTTPRequestOperation *operation, id responseObject) {

            self.sureBtn.enabled = YES;

            NSDictionary *resultDic = [self conversionWithData:responseObject];
            
            
            if ([resultDic[@"code"] integerValue]==0){
                
//                [self getMerchantInfo];
                
                [self.view makeMessage:@"修改成功" duration:3 position:@"center"];

                
                [self.navigationController popViewControllerAnimated:YES];
                
                
            }else{
                
                [self.view makeMessage:resultDic[@"errorMessage"] duration:3 position:@"center"];
                
            }
            
            
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            self.sureBtn.enabled = YES;

            [self.view makeMessage:@"修改失败" duration:2 position:@"center"];
            
            
        }];

        
    }
    
    
    
    
}
#pragma mark !判断选择的时间是否符合要求
- (BOOL)sureTime{

    NSString * alertStr = @"";
    
    if (!beginDate) {
        
        alertStr = @"请开始选择时间";
        
    }else if (!endDate){
    
    
        alertStr = @"请结束选择时间";

        
    }else if ([self compareTimeSizeWithOneTime]){ // !结束时间小于开始时间
    
    
        alertStr = @"截止时间不能早于开始时间";
    
    }else if ([self compareTimeSame]){//!歇业开始时间和截止时间相同
    
    
        alertStr = @"截止时间不能和开始时间相同";

    
    }else if ([self compareTimeSpace]){
    
    
        alertStr = @"歇业时间不可超过3个月";
    
    }
    
    
    if (![alertStr isEqualToString:@""]) {
        
        [self.view makeMessage:alertStr duration:3 position:@"center"];

        return NO;
    }
    

    return YES;

    
}
// !比较两个时间的大小
-(BOOL)compareTimeSizeWithOneTime{

   
    NSComparisonResult result = [beginDate compare:endDate];

    if (result == 1 ) { // !结束时间 小于 开始时间
        
        return  YES;
    
    }else{// !结束时间 大于 开始时间
    
        return  NO;
    
    }
    
}

// !比较两个时间的是否相同
-(BOOL)compareTimeSame{
    
    
    NSComparisonResult result = [beginDate compare:endDate];
    
    if (result == 0) { // !开始时间和结束时间相同
        
        return  YES;
        
        
    }
        
    return  NO;
        
    
}


//!比较开始时间和结束时间 之间的相隔是否大于3个月，大于3个月返回yes
-(BOOL)compareTimeSpace{

    
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    
    int spaceDays=((int)time)/(3600*24);
    
    
    
    if (spaceDays > 30*3) {
        
        return  YES;
        
    }else{
        
        return NO;
    
    }

}

#pragma mark - TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    NSInteger tag = textField.tag;
    
    editTextFieldTag = tag;
    
}

#pragma mark - WMCustomPickerViewDelegate
// !选中时间  确定按钮
-(void)finishDidSelectDatePicker:(WMCustomDatePicker *)datePicker
                            date:(NSDate *)date{
    
    if (editTextFieldTag==1) {
        
        if (date!=nil) {
            
            NSString *nowTime = [self dateFromString:[NSDate date] withFormat:@"yyyy年 MM月 dd日 HH时"];
            NSString *selectedTime = [self dateFromString:date withFormat:@"yyyy年 MM月 dd日 HH时"];
            
            NSDate *freshTime = date;
            
            if ([nowTime isEqualToString:selectedTime]) {
                
                freshTime = [date dateByAddingTimeInterval:90];
                
                selectedTime = [self dateFromString:freshTime withFormat:@"yyyy年 MM月 dd日 HH时"];
            }
            
            _startTimeT.text = [NSString stringWithFormat:@"   %@",selectedTime];
            
            _startFormatterString = [dateFormatter stringFromDate:freshTime];
            
            // !记录开始时间
            beginDate = date;
            
        }
        
    }else{
        
        if (date!=nil) {
            
            _endTimeT.text = [NSString stringWithFormat:@"   %@",[self dateFromString:date withFormat:@"yyyy年 MM月 dd日 HH时"]];
            
            _endFormatterString = [dateFormatter stringFromDate:date];
            
            // !记录结束时间
            endDate = date;
            
        }
        
    }
    
    // !改变确定按钮的状态
    [self changeSureBtnStatue];
    
    
}
// !未选时间的取消按钮
-(void)cancelSelectClick{

    
    // !改变确定按钮的状态
    [self changeSureBtnStatue];

    

}

#pragma mark 改变确定按钮的状态
- (void)changeSureBtnStatue{


    // !如果开始时间和结束时间都选择了，则改变确定按钮的颜色 和可选状态
    if (_startTimeT.text.length >4 && _endTimeT.text.length >4) {
        
        [self.sureBtn setBackgroundColor:[UIColor blackColor]];
//        self.sureBtn.enabled = YES;
        [self.sureBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        
    }else{
    
        
        // !确定按钮置为灰色
//        self.sureBtn.enabled = NO;
        [self.sureBtn setBackgroundColor:[UIColor colorWithHexValue:0xe2e2e2 alpha:1]];
        [self.sureBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        
    
    }
    
    
   

}
- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDatePickerCompleteSelectedNotification object:nil];
    
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDatePickerCanceledNotification object:nil];
    
}

@end
