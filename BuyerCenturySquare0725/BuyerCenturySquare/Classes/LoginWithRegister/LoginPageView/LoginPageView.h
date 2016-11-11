//
//  LoginPageView.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/1/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "CustomButton.h"
#import "CustomTextField2.h"


@protocol LoginPageViewDelegate <NSObject>
//点击注册按钮事件
-(void)registeredButtonAction;
//点击忘记密码按钮事件
-(void)forgetPasswordButtonAction;
//点击登陆按钮事件
-(void)loginButtonActionPhoneNumberText:(NSString *)phoneNumTextField  passwordText:(NSString *)passwordTextField;
//点击显示电话号码按钮事件
-(void)showPhonesListButtonAction:(UIButton *)showListButton;
@end

@interface LoginPageView : UIView<UITableViewDataSource,UITableViewDelegate>
//设置登录账号
@property(strong,nonatomic)CustomTextField2 *phoneNumTextField;
//设置登录密码
@property(strong,nonatomic)CustomTextField *passwordTextField;
//设置注册按钮
@property(strong,nonatomic)CustomButton *registeredButton;
//设置忘记密码按钮
@property(strong,nonatomic)CustomButton *forgetPasswordButton;
//设置登录按钮
@property(strong,nonatomic)CustomButton *loginButton;
//设置展示电话列表按钮
@property(strong,nonatomic)UIButton *showListButton;
//设置代理方法
@property(weak,nonatomic)id<LoginPageViewDelegate>delegate;
//设置电话列表
@property (strong,nonatomic)UITableView *phoneListTable;

@end
