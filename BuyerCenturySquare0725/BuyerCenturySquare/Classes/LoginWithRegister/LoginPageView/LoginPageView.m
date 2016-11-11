//
//  LoginPageView.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/1/15.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "LoginPageView.h"

@implementation LoginPageView
-(id)initWithFrame:(CGRect)frame
{

    if ([super initWithFrame:frame]) {
        
        //设置UIjiemian
        [self makeUI];
    }
    return  self;
}
//设置UIjiemian
-(void)makeUI
{
    //设置登录账号
    self.phoneNumTextField = [[CustomTextField2 alloc]initWithFrame:CGRectMake(0, 11, self.frame.size.width, 30)];
    self.phoneNumTextField.placeholder = NSLocalizedString(@"phonePrompt", @"请输入手机号");
    self.phoneNumTextField.font = [UIFont systemFontOfSize:13];
    self.phoneNumTextField.textColor = LGClickColor;
    [self addSubview:self.phoneNumTextField];
    
    
    
    //展示电话号码按钮
    self.showListButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.showListButton.frame = CGRectMake(self.frame.size.width - 30, self.phoneNumTextField.frame.origin.y, 30, 30);
//    self.showListButton.backgroundColor = [UIColor redColor];
    [self addSubview:self.showListButton];
    [self.showListButton addTarget:self action:@selector(didClickShowListButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.showListButton.userInteractionEnabled = YES;
    [self.showListButton setImage:[UIImage imageNamed:@"down"] forState:(UIControlStateNormal)];
    [self.showListButton setImage:[UIImage imageNamed:@"up"] forState:(UIControlStateSelected)];
    
    
    //设置tableView
    self.phoneListTable = [[UITableView alloc]init];
    self.phoneListTable.delegate = self;
    [self addSubview:self.phoneListTable];
    
    
    
    
    //设置登录密码
    self.passwordTextField = [[CustomTextField alloc]initWithFrame:CGRectMake(self.phoneNumTextField.frame.origin.x, self.phoneNumTextField.frame.origin.y + self.phoneNumTextField.frame.size.height + 11, self.phoneNumTextField.frame.size.width, 30)];
    self.passwordTextField.placeholder = NSLocalizedString(@"passwordPrompt", @"请输入密码");
    self.passwordTextField.font = [UIFont systemFontOfSize:13];
    self.passwordTextField.textColor = LGClickColor;
    [self addSubview:self.passwordTextField];
    
    //设置注册按钮
    self.registeredButton = [[CustomButton alloc]initWithFrame:CGRectMake(self.passwordTextField.frame.origin.x, self.passwordTextField.frame.origin.y + self.passwordTextField.frame.size.height + 12, 150, 13)];
    [self.registeredButton setTitle:@"注册" forState:(UIControlStateNormal)];
    self.registeredButton.titleLabel.font=[UIFont systemFontOfSize:13];
    //设置button上的文字的具体位置，以及做对齐（通过以下两个方法）
    self.registeredButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.registeredButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentLeft;
    self.registeredButton.titleLabel.textAlignment = NSTextAlignmentRight;
    [self addSubview:self.registeredButton];
    [self.registeredButton addTarget:self action:@selector(didClickRegisteredButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    //设置忘记密码按钮
    self.forgetPasswordButton = [[CustomButton alloc]initWithFrame:CGRectMake(self.registeredButton.frame.size.width,self.registeredButton.frame.origin.y, self.frame.size.width - self.registeredButton.frame.size.width, self.registeredButton.frame.size.height)];
    [self.forgetPasswordButton setTitle:@"忘记密码" forState:(UIControlStateNormal)];
    self.forgetPasswordButton.titleLabel.font=[UIFont systemFontOfSize:13];
    //设置button上的文字的具体位置，以及做对齐（通过以下两个方法）
    self.forgetPasswordButton.titleEdgeInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    self.forgetPasswordButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [self addSubview:self.forgetPasswordButton];
    [self.forgetPasswordButton addTarget:self action:@selector(didClickForgetPasswordButtonAction) forControlEvents:UIControlEventTouchUpInside];
    
    
    //设置登录按钮
    self.loginButton = [[CustomButton alloc]initWithFrame:CGRectMake(0, self.forgetPasswordButton.frame.origin.y + 22 + self.forgetPasswordButton.frame.size.height, self.frame.size.width, 44)];
    [self addSubview:self.loginButton];
    self.loginButton.layer.masksToBounds = YES;
    self.loginButton.layer.borderColor = LGButtonColor.CGColor;
    self.loginButton.layer.borderWidth = 1;
    self.loginButton.layer.cornerRadius = 3;
    [self.loginButton setTitle:@"登录" forState:(UIControlStateNormal)];
    self.loginButton.titleLabel.font=[UIFont systemFontOfSize:15];
     [self.loginButton addTarget:self action:@selector(didClickLoginButtonAction) forControlEvents:UIControlEventTouchUpInside];
}
//点击显示电话号码按钮事件
-(void)didClickShowListButtonAction
{
    
    if ([self.delegate respondsToSelector:@selector(showPhonesListButtonAction:)]) {
        [self.delegate showPhonesListButtonAction:self.showListButton];
    }
    
}
//点击注册按钮事件
-(void)didClickRegisteredButtonAction
{
    if ([self.delegate respondsToSelector:@selector(registeredButtonAction)]) {
        [self.delegate performSelector:@selector(registeredButtonAction)];
    }

}
//点击忘记密码按钮事件
-(void)didClickForgetPasswordButtonAction
{
    if ([self.delegate respondsToSelector:@selector(forgetPasswordButtonAction)]) {
        [self.delegate performSelector:@selector(forgetPasswordButtonAction)];
    }

    
}
//点击登陆按钮事件
-(void)didClickLoginButtonAction
{
    if ([self.delegate respondsToSelector:@selector(loginButtonActionPhoneNumberText:passwordText:)]) {
        
        [self.delegate loginButtonActionPhoneNumberText:self.phoneNumTextField.text passwordText:self.passwordTextField.text];
    }
}


#pragma mark--------------tableView代理方法-----------------------------
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 8;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 41;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Cell"];
    
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"Cell"];
    }
    
    return cell;
}

@end
