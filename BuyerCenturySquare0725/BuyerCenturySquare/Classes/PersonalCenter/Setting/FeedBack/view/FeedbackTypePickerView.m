//
//  FeedbackTypePickerView.m
//  CustomerCenturySquare
//
//  Created by 张晓旭 on 16/7/7.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "FeedbackTypePickerView.h"
#import "CSPFeedBackTypeDTO.h"
@interface FeedbackTypePickerView ()

{
    NSMutableArray *arr;
}
@property(nonatomic,strong)NSMutableArray *arrData;
@end

@implementation FeedbackTypePickerView


-(void)awakeFromNib
{
    //数据请求
    [self getFeedbackDataList];
    self.feedbackPickerView.delegate = self;
    self.feedbackPickerView.dataSource = self;
    //创建可变数组
    self.arrData = [NSMutableArray arrayWithCapacity:0];

}


#pragma mark-加载反馈类型
-(void)getFeedbackDataList
{
    [HttpManager sendHttpRequestFeedBackTypeSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary* dic = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];

        if ([dic[@"code"] isEqualToString:@"000"]) {
            
            arr = [dic[@"data"] mutableCopy];

            for (NSDictionary *dic in arr) {
                CSPFeedBackTypeDTO * feedBackTypeDTO = [[CSPFeedBackTypeDTO alloc]init];
                [feedBackTypeDTO setDictFrom:dic];
                
                [self.arrData addObject:feedBackTypeDTO];
    
            }
            [self.feedbackPickerView reloadAllComponents];
        }
    
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
    }];
}

#pragma mark -----PickerView  delegate方法----
- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.arrData.count;
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    CSPFeedBackTypeDTO * feedBackTypeDTO = [[CSPFeedBackTypeDTO alloc]init];
    feedBackTypeDTO = self.arrData[row];
    return feedBackTypeDTO.typeName;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    
    CSPFeedBackTypeDTO * feedBackTypeDTO = [[CSPFeedBackTypeDTO alloc]init];
    feedBackTypeDTO = self.arrData[row];
    
    NSDictionary *dic = @{@"name":feedBackTypeDTO};
    
    NSNotification *notification = [[NSNotification alloc]initWithName:@"FeedType" object:self userInfo:dic];
    [[NSNotificationCenter defaultCenter]postNotification:notification];
}


@end
