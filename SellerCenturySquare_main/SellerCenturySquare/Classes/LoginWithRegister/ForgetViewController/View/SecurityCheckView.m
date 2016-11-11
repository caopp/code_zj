//
//  SecurityCheckView.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 16/1/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "SecurityCheckView.h"
#import "CustomTextField.h"
#import "CustomButton.h"
#import "JKCountDownButton.h"
#import "UIColor+UIColor.h"

/**
 *  设置登录显示框中的线条和Placeholder的颜色
 */
#define LGNOClickColor [UIColor colorWithHexValue:0xffffff alpha:0.3] //线条颜色
#define LGClickColor [UIColor colorWithHexValue:0xffffff alpha:1]  //点击后线条
#define LGButtonColor [UIColor colorWithHexValue:0xffffff alpha:0.7]  //点击后线条
@interface SecurityCheckView()
{
    //倒计时
    JKCountDownButton *countdownButton;
}
@end
@implementation SecurityCheckView
-(id)initWithFrame:(CGRect)frame
{
    if ([super initWithFrame:frame]) {
       
        //设置UI界面
        [self makeUI];
    }
    return self;
}
//设置UI界面
-(void)makeUI
{
    //设置输入手机电话号码textfield
    self.phoneTextField = [[CustomTextField alloc]initWithFrame:CGRectMake(0, 11, self.frame.size.width, 30)];
    self.phoneTextField.placeholder = @"请输入注册时使用的手机号码";
    [self addSubview:self.phoneTextField];
    self.phoneTextField.font = [UIFont systemFontOfSize:13];
    self.phoneTextField.textColor = LGClickColor;
    
    
    //设置键盘
    self.phoneTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    //输入输入使用的验证码
    self.codeTextField = [[CustomTextField alloc]initWithFrame:CGRectMake(0, self.phoneTextField.frame.origin.y + 11 + self.phoneTextField.frame.size.height, self.phoneTextField.frame.size.width - 124, 30)];
    [self addSubview:self.codeTextField];
    self.codeTextField.font = [UIFont systemFontOfSize:13];
    self.codeTextField.textColor = LGClickColor;
    
    
    //设置键盘
    self.codeTextField.keyboardType = UIKeyboardTypeNumberPad;
    //设置点击选中后秒数倒计时按钮
    countdownButton = [[JKCountDownButton alloc]initWithFrame:CGRectMake(self.frame.size.width - 106, self.codeTextField.frame.origin.y, 106, 30)];
    [self addSubview:countdownButton];
    [countdownButton setTitle:@"获取验证码" forState:(UIControlStateNormal)];
    [countdownButton addTarget:self action:@selector(didClickCountdownAction) forControlEvents:UIControlEventTouchUpInside];
    countdownButton.titleLabel.font=[UIFont systemFontOfSize:13];
    [countdownButton setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
    countdownButton.layer.borderColor = LGButtonColor.CGColor;
    countdownButton.layer.borderWidth = 1;
    countdownButton.layer.masksToBounds = YES;
    countdownButton.layer.cornerRadius = 3;
    
    
    //下一步按钮
    self.nextButton = [[CustomButton alloc]initWithFrame:CGRectMake(0, self.codeTextField.frame.origin.y + self.codeTextField.frame.size.height + 13 , self.frame.size.width, 41)];
    [self addSubview:self.nextButton];
    [self.nextButton setTitle:@"下一步" forState:(UIControlStateNormal)];
    self.nextButton.titleLabel.font=[UIFont systemFontOfSize:15];
    [self.nextButton setTitleColor:LGButtonColor forState:(UIControlStateNormal)];
    [self.nextButton addTarget:self action:@selector(didClickNextButtonAction) forControlEvents:UIControlEventTouchUpInside];
    self.nextButton.layer.borderColor = LGButtonColor.CGColor;
    self.nextButton.layer.borderWidth = 1;
    self.nextButton.layer.masksToBounds = YES;
    self.nextButton.layer.cornerRadius = 3;
    
    
}
//倒计时按钮点击事件
-(void)didClickCountdownAction
{
    if ([self.delegate respondsToSelector:@selector(countdownActionPhoneText:countdownButton:)]) {
        [self.delegate countdownActionPhoneText:self.phoneTextField.text countdownButton:countdownButton];
    }
}
//点击下一步按钮事件
-(void)didClickNextButtonAction
{
    if ([self.delegate respondsToSelector:@selector(nextActionPhoneText: CodeText:)]) {
        [self.delegate nextActionPhoneText:self.phoneTextField.text CodeText:self.codeTextField.text];

        
    }
}
-(void)timeEnough
{
   }

@end
