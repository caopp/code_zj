//
//  CSPChangePasswordView.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/1/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CustomTextField.h"
#import "CustomButton.h"

@protocol CSPChangePasswordViewDelegate <NSObject>
-(void)submitNewSecretText:(NSString *)newSecretText repeatSecretText:(NSString *)repeatSecretText;
@end

@interface CSPChangePasswordView : UIView
//设置新密码
@property(strong,nonatomic) CustomTextField *secretTextField;
//重复设置新密码
@property(strong,nonatomic) CustomTextField *repeatSecretTextField;
//输入密码显示格式
@property(strong,nonatomic) UILabel *inputFormatLabel;
//密码显示按钮
@property(strong,nonatomic) UIButton *secretShowButton;
//显示密码label
@property(strong,nonatomic) UILabel *secretShowLabel;
//提交按钮
@property(strong,nonatomic) CustomButton *submitButton;
//设置代理属性
@property(weak,nonatomic)id<CSPChangePasswordViewDelegate>delegate;
@end
