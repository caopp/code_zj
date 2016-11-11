//
//  CSPInputPasswordView.m
//  BuyerCenturySquare
//
//  Created by Edwin on 15/9/18.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPInputPasswordView.h"

@implementation CSPInputPasswordView


-(void)awakeFromNib{
    
    UITapGestureRecognizer *backgroundViewTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(backgroundViewTaped:)];
    backgroundViewTap.delegate = self;
    [self addGestureRecognizer:backgroundViewTap];
    
    UITapGestureRecognizer *forgetLabelTap = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(forgetLabelTaped:)];
    [self.forgetPasswordLabel addGestureRecognizer:forgetLabelTap];
    self.forgetPasswordLabel.userInteractionEnabled = YES;
    
    _passwordTextField.secureTextEntry = YES;
    
    self.backgroundView.layer.cornerRadius = 9.0f;
    self.backgroundView.layer.masksToBounds = YES;
    
    
}



-(void)backgroundViewTaped:(UITapGestureRecognizer *)gesture
{
    [self.delegate cspInputViewcancelSelfViewMethod];
    [self removeFromSuperview];
}

- (IBAction)cancelButtonClicked:(id)sender {
    
    [self.delegate cspInputViewcancelSelfViewMethod];
    [self removeFromSuperview];
}

- (IBAction)confirmButtonClicked:(id)sender {
    if (self.delegate && [self.delegate respondsToSelector:@selector(confirmClickedwithPassword:)]) {
        [self.delegate confirmClickedwithPassword:self.passwordTextField.text];
    }
    [self removeFromSuperview];
}

-(void)forgetLabelTaped:(UITapGestureRecognizer *)gesture
{
    if (self.delegate && [self.delegate respondsToSelector:@selector(forgetPasswordClicked)]) {
        [self.delegate forgetPasswordClicked];
    }
    [self removeFromSuperview];
}

-(BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer shouldReceiveTouch:(UITouch *)touch
{
    if ([touch.view isEqual:self.backgroundView]) {
        return NO;
    }
    return YES;
}
@end
