//
//  CSPSettingChangePasswordViewController.h
//  BuyerCenturySquare
//
//  Created by GuChenlong on 7/13/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//  !修改登录密码  修改支付密码   忘记支付密码

#import "BaseViewController.h"

@interface CSPSettingChangePasswordViewController : BaseViewController

@property (nonatomic,assign)CSPChangePassword changePassword;
@property (nonatomic,copy)NSString *account;


@end
