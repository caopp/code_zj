//
//  ChangePwdView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/1/21.
//  Copyright © 2016年 pactera. All rights reserved.
//
//定义公共的颜色设置（添加的)
#import "UIColor+UIColor.h"
#import "ChangePwdView.h"
/**
 *  设置登录显示框中的线条和Placeholder的颜色
 */
#define LGNOClickColor [UIColor colorWithHexValue:0xffffff alpha:0.3] //线条颜色
#define LGClickColor [UIColor colorWithHexValue:0xffffff alpha:1]  //点击后线条
#define LGButtonColor [UIColor colorWithHexValue:0xffffff alpha:0.7]  //点击后线条
#define PlaceholderColor [UIColor colorWithHexValue:0xffffff alpha:0.5]TT

@implementation ChangePwdView
-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
        
        //设置UI界面
        [self makeUI];
        
    }
    return self;
}


#pragma mark ========设置UI 界面====
-(void)makeUI
{
    //设置新密码
    self.secretTextField = [[CustomTextField alloc]initWithFrame:CGRectMake(0, 0, self.frame.size.width, 30)];
    self.secretTextField.placeholder = @"新密码";
    [self addSubview:self.secretTextField];
    self.secretTextField.font = [UIFont systemFontOfSize:13];
    self.secretTextField.textColor = LGClickColor;
    [self.secretTextField setSecureTextEntry:YES];
    
    //设置键盘
    self.secretTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    //重新输入新密码
    self.repeatSecretTextField = [[CustomTextField alloc]initWithFrame:CGRectMake(0, self.secretTextField.frame.origin.y + 11 + self.secretTextField.frame.size.height, self.secretTextField.frame.size.width, 30)];
    self.repeatSecretTextField.font = [UIFont systemFontOfSize:13];
    self.repeatSecretTextField.textColor = LGClickColor;
    [self addSubview:self.repeatSecretTextField];
    self.repeatSecretTextField.placeholder = @"重新输入新密码";
    [self.repeatSecretTextField setSecureTextEntry:YES];
    //设置键盘
    self.repeatSecretTextField.keyboardType = UIKeyboardTypeASCIICapable;
    //显示输入框格式
    self.inputFormatLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.repeatSecretTextField.frame.origin.x, self.repeatSecretTextField.frame.origin.y + self.repeatSecretTextField.frame.size.height + 7, self.frame.size.width, 13)];
    [self addSubview:self.inputFormatLabel];
    self.inputFormatLabel.textAlignment = NSTextAlignmentLeft;
    self.inputFormatLabel.text = @"密码由6－12位英文字母、数字或符号组成";
    self.inputFormatLabel.font = [UIFont systemFontOfSize:10];
    self.inputFormatLabel.textColor = LGClickColor;
    
    //设置显示密码按钮
    self.secretShowButton = [UIButton buttonWithType:(UIButtonTypeCustom)];
    self.secretShowButton.frame = CGRectMake(self.inputFormatLabel.frame.origin.x, self.inputFormatLabel.frame.origin.y + self.inputFormatLabel.frame.size.height + 9, 16, 16);
    [self addSubview:self.secretShowButton];
    [self.secretShowButton addTarget:self action:@selector(didClickNoShowSecretButtonoAction) forControlEvents:UIControlEventTouchUpInside];
    self.secretShowButton.userInteractionEnabled = YES;
    self.secretShowButton.selected = YES;
    [self.secretShowButton setImage:[UIImage imageNamed:@"02_注册_选中"] forState:(UIControlStateNormal)];
    [self.secretShowButton setImage:[UIImage imageNamed:@"02_注册_未选中"] forState:(UIControlStateSelected)];
    
    
    //显示密码label
    self.secretShowLabel = [[UILabel alloc]initWithFrame:CGRectMake(self.secretShowButton.frame.origin.x + self.secretShowButton.frame.size.width + 5 , self.secretShowButton.frame.origin.y + 3, 100, 10)];
    self.secretShowLabel.text = @"显示密码";
    self.secretShowLabel.font = [UIFont systemFontOfSize:10];
    self.secretShowLabel.textColor = LGClickColor;
    [self addSubview:self.secretShowLabel];
    
    
    //提交
    self.submitButton = [[CustomButton alloc]initWithFrame:CGRectMake(0 , self.secretShowButton.frame.origin.y + self.secretShowButton.frame.size.height + 10, self.frame.size.width, 43)];
    [self addSubview:self.submitButton];
    [self.submitButton setTitle:@"提交" forState:(UIControlStateNormal)];
    self.submitButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.submitButton setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
    [self.submitButton addTarget:self action:@selector(didClickSubmitButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.submitButton.layer.borderColor = LGButtonColor.CGColor;
    self.submitButton.layer.borderWidth = 1;
    self.submitButton.layer.masksToBounds = YES;
    self.submitButton.layer.cornerRadius = 3;
    
}

//提交按钮进行事件
-(void)didClickSubmitButtonAction
{
    //设置代理方法
    if ([self.delegate respondsToSelector:@selector(submitNewSecretText:repeatSecretText:)]) {
        [self.delegate submitNewSecretText:self.secretTextField.text repeatSecretText:self.repeatSecretTextField.text];
    }
}

//不现实密码
-(void)didClickNoShowSecretButtonoAction
{
    //不平等的选择结果,根据状态的不同，执行各种不相同的方法
    self.secretShowButton.selected =!self.secretShowButton.selected;
    if (self.secretShowButton.selected == YES) {
        [self.secretTextField setSecureTextEntry:YES];
        [self.repeatSecretTextField setSecureTextEntry:YES];
    }
    
    if (self.secretShowButton.selected == NO) {
        [self.secretTextField setSecureTextEntry:NO];
        [self.repeatSecretTextField setSecureTextEntry:NO];
    }
}




@end
