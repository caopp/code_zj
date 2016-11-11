//
//  CSPModifyPriceView.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/20.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPModifyPriceView.h"
#import "Masonry.h"

@implementation CSPModifyPriceView


- (void)awakeFromNib{
    
    self.amoutTextField.delegate = self;
    self.amoutTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    self.amoutTextField.layer.borderColor = [[UIColor lightGrayColor] CGColor];
    
    self.amoutTextField.layer.borderWidth = 0.5f;
    //倒角
    self.amoutTextField.layer.cornerRadius = 5;
    
    self.backgroundView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.7];
    
//    self.amoutTextField.keyboardType = UIKeyboardTypeASCIICapable;
    
    
    self.contentView.layer.cornerRadius=5;
    
    [self registerForKeyboardNotifications];
    
}






- (void) registerForKeyboardNotifications
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWasShown:) name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter]  addObserver:self selector:@selector(keyboardWasHidden:) name:UIKeyboardDidHideNotification object:nil];
}
//键盘弹起
- (void) keyboardWasShown:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    
    NSLog(@"keyBoard:%f", keyboardSize.height);  //216
    
    CGFloat contentViewHeight =[UIScreen mainScreen].bounds.size.height -  self.contentView.frame.origin.y-self.contentView.frame.size.height-64;
    contentViewOrigin = self.contentView.frame.origin.y;
    
    if (contentViewHeight <keyboardSize.height) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect = self.contentView.frame;
            rect.origin.y -= keyboardSize.height-contentViewHeight;
            self.contentView.frame = rect;
        }];
    }
}

//键盘收回
- (void) keyboardWasHidden:(NSNotification *) notif
{
    NSDictionary *info = [notif userInfo];
    
    NSValue *value = [info objectForKey:UIKeyboardFrameBeginUserInfoKey];
    CGSize keyboardSize = [value CGRectValue].size;
    DebugLog(@"keyboardWasHidden keyBoard:%f", keyboardSize.height);
    // keyboardWasShown = NO;
    
    if (contentViewOrigin) {
        [UIView animateWithDuration:0.2 animations:^{
            CGRect rect = self.contentView.frame;
            rect.origin.y =contentViewOrigin;
            self.contentView.frame = rect;
            
        }];
    }
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
    //    [self removeFromSuperview];
    [self.amoutTextField endEditing:YES];
}

- (IBAction)cancelButtonClick:(id)sender {
    
    [self removeFromSuperview];
}

- (IBAction)confirmButtonClick:(id)sender {
    
    
    
    if (self.amoutTextField.text.doubleValue <=0) {
        
        [self makeMessage:@"输入的价钱不能为0" duration:2.0 position:@"center"];
        
        return;
        
    }
    [self removeFromSuperview];
    
    if ([self.requestType isEqualToString:@"delegate"]) {
        
        [self.delegate cspModifyPricechangeOrderTotal:self];
        
    }else if ([self.requestType isEqualToString:@"block"])
    {

        if (self.confirmBlock) {
            
            self.confirmBlock();

        }
        
        
    }
    
}



#pragma mark-UITextFieldDelegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField{

    [textField resignFirstResponder];
    return YES;

}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{


    //!对输入的内容限制，只允许用户输入到小数点第二位
    
    NSArray * textArray = [textField.text componentsSeparatedByString:@"."];
    

    if (textArray.count == 2) {//!如果数组中有两个值，则说明输入了小数点

        NSRange ran=[textField.text rangeOfString:@"."];
        
        int tt=range.location-ran.location;//!将要修改的位置-小数点在的位置
        
        if (tt <= 2){
            return YES;
        }

    
        return NO;
        
    }
    

    if ([textField.text rangeOfString:@"."].location != NSNotFound) {
        
        //条件为真，表示字符串searchStr包含一个自字符串substr
        if (range.location >10) {
            return NO;
        }

        
    }else
    {
        //条件为假，表示不包含要检查的字符串
        if (range.location >8) {
            return NO;
        }

    }

   

    return YES;

}

-(void)dealloc{

    
    //!移除通知
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidShowNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardDidHideNotification object:nil];


}
@end













