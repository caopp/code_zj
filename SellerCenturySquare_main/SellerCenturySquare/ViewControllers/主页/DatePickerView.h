//
//  DatePickerView.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/6.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DatePickerView : UIViewController<UIPickerViewDelegate>

@property (weak, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (nonatomic,copy) NSString *dateStr;
@property (nonatomic,copy) NSString *formatterDateStr;
@property (nonatomic,assign) NSDate *date;

@end
