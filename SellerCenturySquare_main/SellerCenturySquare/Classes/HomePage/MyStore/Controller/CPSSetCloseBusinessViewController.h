//
//  CPSSetCloseBusinessViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/5.
//  Copyright (c) 2015年 pactera. All rights reserved.
//  设置歇业

#import <UIKit/UIKit.h>
#import "BaseViewController.h"
#import "WMCustomDatePicker.h"

@interface CPSSetCloseBusinessViewController : BaseViewController<UITextFieldDelegate,WMCustomDatePickerDelegate>

@property (weak, nonatomic) IBOutlet UITextField *startTimeT;
@property (weak, nonatomic) IBOutlet UITextField *endTimeT;

@property (nonatomic,copy) NSString *startFormatterString;
@property (nonatomic,copy) NSString *endFormatterString;

// !确定按钮
@property (weak, nonatomic) IBOutlet UIButton *sureBtn;


@end
