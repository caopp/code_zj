//
//  ModCloseBusinessTimeViewController.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ModCloseBusinessTimeViewController.h"
#import "WMCustomDatePicker.h"

@interface ModCloseBusinessTimeViewController ()
{
    NSInteger editTextFieldTag;
    NSDateFormatter *dateFormatter;
}
@end

@implementation ModCloseBusinessTimeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.    
    dateFormatter = [[NSDateFormatter alloc]init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    [self customBackBarButton];
    
}

- (void)viewWillAppear:(BOOL)animated{
    
    [self initTextField];
    
}

- (void)dealloc{
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDatePickerCompleteSelectedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kDatePickerCanceledNotification object:nil];
    
}

- (void)textFieldVisiableInit{
    
    if (_startFormatterString) {
        
        _startTimeT.text = [self dateChangeFormatter:_startFormatterString];
        
    }
    
    if (_endFormatterString) {
        
        _endTimeT.text = [self dateChangeFormatter:_endFormatterString];
        
    }
    
}

- (NSString*)dateChangeFormatter:(NSString*)string{
    
    NSString *resultStr = [[NSString alloc]init];
    
    NSDateFormatter *oldDateFormatter = [[NSDateFormatter alloc]init];
    [oldDateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    
    NSDateFormatter *newDateFormatter = [[NSDateFormatter alloc]init];
    [newDateFormatter setDateFormat:@"yyyy年MM月dd日 HH时"];

    NSDate *time = [oldDateFormatter dateFromString:string];
    
    resultStr = [newDateFormatter stringFromDate:time];
    
    return resultStr;
}

#pragma mark - HttpRequest
- (void)modShopCloseTime{
    
    
    if ([self sureTime]) {
        
        
        NSString* operateStatus = @"1";
        NSString* closeStartTime = _startFormatterString;
        NSString* closeEndTime = _endFormatterString;
        
        self.sureBtn.enabled = NO;
        
        [HttpManager sendHttpRequestForGetUpdateMerchantBusiness: operateStatus closeStartTime:closeStartTime closeEndTime:closeEndTime success:^(AFHTTPRequestOperation *operation, id responseObject) {
            
            self.sureBtn.enabled = YES;

            NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
            
            if ([[dic objectForKey:@"code"]isEqualToString:@"000"]) {
                
                
                //更该营业状态（包括歇业时间） 返回正常编码。
                //            GetMerchantInfoDTO *getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
                //            [getMerchantInfoDTO setDictFrom:[dic objectForKey:@"data"]];
                //            [self getMerchantInfo];
                [self.view makeMessage:@"修改成功" duration:3 position:@"center"];

                [self.navigationController popViewControllerAnimated:YES];
                
            }else{
                
                [self.view makeMessage:dic[@"errorMessage"] duration:3 position:@"center"];
                
            }
            
            
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            
            self.sureBtn.enabled = YES;

            [self.view makeMessage:@"修改失败" duration:3 position:@"center"];
            
            
        } ];

        
    }
    

}

#pragma mark !判断选择的时间是否符合要求
- (BOOL)sureTime{
    
    // !开始时间 格式：2015-11-23 18:00:30
    NSDateFormatter *inputFormatter = [[NSDateFormatter alloc] init];
    [inputFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate* startDate = [inputFormatter dateFromString:_startFormatterString];
    
    
    // !结束时间
    NSDate* endDate = [inputFormatter dateFromString:_endFormatterString];

    
    
    NSString * alertStr = @"";
    
    if ([self compareTimeSizeWithOneTime:startDate endDate:endDate]){ // !结束时间小于开始时间
        
        alertStr = @"歇业时间截止时间不能早于歇业开始时间";
        
        
    }else if ([self compareTimeSpace:startDate endDate:endDate]){
        
        
        alertStr = @"歇业时间不可超过3个月";
        
    }
    
    
    if (![alertStr isEqualToString:@""]) {
        
        [self.view makeMessage:alertStr duration:3 position:@"center"];
        
        return NO;
    }
    
    
    return YES;
    
    
}
// !比较两个时间的大小
-(BOOL)compareTimeSizeWithOneTime:(NSDate *)beginDate endDate:(NSDate *)endDate{
    
    
    NSComparisonResult result = [beginDate compare:endDate];
    
    if (result == 1) { // !结束时间 小于 开始时间
        
        return  YES;
        
    }else{// !结束时间 大于 开始时间
        
        return  NO;
        
    }
    
}
//!比较开始时间和结束时间 之间的相隔是否大于3个月，大于3个月返回yes
-(BOOL)compareTimeSpace:(NSDate *)beginDate endDate:(NSDate *)endDate{
    
    
    NSTimeInterval time=[endDate timeIntervalSinceDate:beginDate];
    
    int spaceDays=((int)time)/(3600*24);
    
    
    
    if (spaceDays > 30*3) {
        
        return  YES;
        
    }else{
        
        return NO;
        
    }
    
}

#pragma mark -Private Functions

- (void)initTextField{
    
    WMCustomDatePicker *WMDatePickerView = [[WMCustomDatePicker alloc]initWithframe:CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 200) Delegate:self PickerStyle:WMDateStyle_YearMonthDayHour];
    WMDatePickerView.minLimitDate = [NSDate date];
    WMDatePickerView.maxLimitDate = [NSDate dateWithTimeIntervalSinceNow:24*60*60*30*12];
    WMDatePickerView.hasToolbar = YES;
    WMDatePickerView.delegate = self;
    
    _startTimeT.inputView = WMDatePickerView;
    _endTimeT.inputView = WMDatePickerView;

    [self textFieldVisiableInit];
}

-(void)finishDidSelectDatePicker:(WMCustomDatePicker *)datePicker
                            date:(NSDate *)date{
    
    if (editTextFieldTag==1) {
        
        if (date!=nil) {
            _startTimeT.text = [NSString stringWithFormat:@"  %@",[self dateFromString:date withFormat:@"yyyy年 MM月 dd日 HH时"]];
            
            _startFormatterString = [dateFormatter stringFromDate:date];
            
        }
        
    }else{
        
        if (date!=nil) {
            
            _endTimeT.text = [NSString stringWithFormat:@"  %@",[self dateFromString:date withFormat:@"yyyy年 MM月 dd日 HH时"]];
            
            _endFormatterString = [dateFormatter stringFromDate:date];
        }
        
    }
}

- (void)updateTextFieldWhenDatePickerCanceled{
    
    [self.view endEditing:YES];
}

- (IBAction)comfirmButtonClicked:(id)sender {
    
    [self modShopCloseTime];
    
}

#pragma mark - TextFieldDelegate
- (void)textFieldDidBeginEditing:(UITextField *)textField{
    
    
    NSInteger tag = textField.tag;
    
    editTextFieldTag = tag;
    
    // !开始日期
    if (editTextFieldTag == 1) {
        
        
        [self.view endEditing:YES];
        
        [self.view makeMessage:@"正在歇业中，仅可修改歇业截止时间！" duration:2 position:@"center"];
        
        
    }
    
    
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
