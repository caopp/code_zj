//
//  CountConditionEditedTableViewCell.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/5.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CountConditionEditedTableViewCell : UITableViewCell<UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UISwitch *stateOn;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *countTextFieldWidth;


@end
