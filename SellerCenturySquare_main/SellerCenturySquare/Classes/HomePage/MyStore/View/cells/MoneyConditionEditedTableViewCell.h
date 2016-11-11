//
//  MoneyConditionEditedTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/5.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MoneyConditionEditedTableViewCell : UITableViewCell<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *textField;


@property (weak, nonatomic) IBOutlet UISwitch *stateOn;

//!输入框的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *moneyTextFieldWidth;


@end
