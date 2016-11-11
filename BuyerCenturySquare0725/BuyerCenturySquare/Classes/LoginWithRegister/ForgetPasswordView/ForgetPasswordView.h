//
//  ForgetPasswordView.h
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 16/1/13.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CustomButton,JKCountDownButton,CustomTextField;
@protocol ForgetPasswordViewDelegate <NSObject>
//点击倒计时按钮
-(void)countdownActionPhoneText:(NSString *)phoneText countdownButton:(JKCountDownButton *)codeButton;
//下一步按钮
-(void)nextActionPhoneText:(NSString *)phoneText CodeText:(NSString *)codeText;
@end
@interface ForgetPasswordView : UIView
//设置输入手机电话号码textfield
@property (nonatomic,strong)CustomTextField *phoneTextField;
//输入输入使用的验证码
@property (nonatomic,strong)CustomTextField *codeTextField;
//下一步按钮
@property (nonatomic,strong)CustomButton *nextButton;
@property(weak,nonatomic)id<ForgetPasswordViewDelegate>delegate;
@end
