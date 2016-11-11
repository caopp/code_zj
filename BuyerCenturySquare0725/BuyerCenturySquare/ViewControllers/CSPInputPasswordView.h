//
//  CSPInputPasswordView.h
//  BuyerCenturySquare
//
//  Created by Edwin on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

@protocol CSPInputViewDelegate <NSObject>

-(void)confirmClickedwithPassword:(NSString *)string;
-(void)forgetPasswordClicked;
//移除本视图时执行的方法，允许所有按钮交互
- (void)cspInputViewcancelSelfViewMethod;

@end

#import <UIKit/UIKit.h>
#import "CSPSettingsTextField.h"

@interface CSPInputPasswordView : UIView<UIGestureRecognizerDelegate>
@property (weak, nonatomic) IBOutlet UIView *backgroundView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *MoneyLabel;
@property (weak, nonatomic) IBOutlet CSPSettingsTextField *passwordTextField;
@property (weak, nonatomic) IBOutlet UILabel *forgetPasswordLabel;
@property (weak, nonatomic) IBOutlet UIButton *cancelButton;
@property (weak, nonatomic) IBOutlet UIButton *confirmButton;
- (IBAction)cancelButtonClicked:(id)sender;
- (IBAction)confirmButtonClicked:(id)sender;

@property (nonatomic,assign)id<CSPInputViewDelegate>delegate;


@end
