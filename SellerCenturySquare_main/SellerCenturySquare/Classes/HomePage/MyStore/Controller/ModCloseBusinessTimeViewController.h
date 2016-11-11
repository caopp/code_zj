//
//  ModCloseBusinessTimeViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/7.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"
#import "WMCustomDatePicker.h"
@interface ModCloseBusinessTimeViewController : BaseViewController<WMCustomDatePickerDelegate>
@property (weak, nonatomic) IBOutlet UITextField *startTimeT;
@property (weak, nonatomic) IBOutlet UITextField *endTimeT;


@property (weak, nonatomic) IBOutlet UIButton *sureBtn;

@property (nonatomic,copy) NSString *startFormatterString;
@property (nonatomic,copy) NSString *endFormatterString;

@end
