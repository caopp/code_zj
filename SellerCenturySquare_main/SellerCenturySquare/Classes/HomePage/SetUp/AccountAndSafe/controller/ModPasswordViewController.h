//
//  ModPasswordViewController.h
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/13.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "BaseViewController.h"

@interface ModPasswordViewController : BaseViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *oldLoginPwdT;
@property (weak, nonatomic) IBOutlet UITextField *freshLoginPwdT;
@property (weak, nonatomic) IBOutlet UIButton *showPwdButton;

//!修改按钮
@property (weak, nonatomic) IBOutlet UIButton *mobileBtn;

@end
