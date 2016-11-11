//
//  FeedbackTypePickerView.m
//  CustomerCenturySquare
//
//  Created by 张晓旭 on 16/7/7.
//  Copyright © 2016年 zuojian. All rights reserved.
//

#import "FeedbackTypePickerView.h"
@interface FeedbackTypePickerView ()

@property(nonatomic,strong)NSMutableArray *arrData;
@end

@implementation FeedbackTypePickerView

-(void)awakeFromNib
{
    self.feedbackPickerView.delegate = self;
    
    self.feedbackPickerView.dataSource = self;
    //创建可变数组
    self.arrData = [NSMutableArray arrayWithCapacity:0];
    
    self.feedbackPickerView.autoresizingMask = UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
    
    //创造数据
    NSDictionary *dic = [NSDictionary dictionaryWithObjectsAndKeys:@"0",@"queryType",@"全部",@"queryTypeName", nil];
    
    NSDictionary *dic1 = [NSDictionary dictionaryWithObjectsAndKeys:@"1",@"queryType",@"窗口图、参考图均已设置默认图",@"queryTypeName", nil];
    
    NSDictionary *dic2 = [NSDictionary dictionaryWithObjectsAndKeys:@"2",@"queryType",@"窗口图、参考图均未设置默认图",@"queryTypeName", nil];
    
    NSDictionary *dic3 = [NSDictionary dictionaryWithObjectsAndKeys:@"3",@"queryType",@"已设置窗口默认图，未设置参考默认图",@"queryTypeName", nil];
    
    NSDictionary *dic4 = [NSDictionary dictionaryWithObjectsAndKeys:@"4",@"queryType",@"未设置窗口默认图，已设置参考默认图",@"queryTypeName", nil];
    
    self.arrData = [NSMutableArray arrayWithObjects:dic,dic1,dic2, dic3,dic4,nil];
    
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
      return self.arrData[row][@"queryTypeName"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    NSDictionary *dic = self.arrData[row];
    
    NSNotification *notification = [[NSNotification alloc]initWithName:@"FeedType" object:self userInfo:dic];

    [[NSNotificationCenter defaultCenter]postNotification:notification];
}


- (UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view
{
    UILabel *myView = nil;
    
    if (component == 0) {
        myView = [[UILabel alloc] initWithFrame:CGRectMake(0.0, 0.0, SCREEN_WIDTH, 20)];
        
        myView.textAlignment = UITextAlignmentCenter;
        
        myView.text = self.arrData[row][@"queryTypeName"];
        
        if ([UIScreen mainScreen].bounds.size.width == 320.0) {
            myView.font = [UIFont systemFontOfSize:15];         //用label来设置字体大小
        }else
        {
           myView.font = [UIFont systemFontOfSize:19];         //用label来设置字体大小
        }
        

    }
    return myView;
}



@end
