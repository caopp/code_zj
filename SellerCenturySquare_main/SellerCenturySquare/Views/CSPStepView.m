//
//  CSPStepView.m
//  SellerCenturySquare
//
//  Created by clz on 15/8/28.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CSPStepView.h"

@implementation CSPStepView

- (void)awakeFromNib{
    
    self.stepMinPriceTextField.delegate = self;
    
    self.stepMaxPriceTextField.delegate = self;
    
    self.priceTextField.delegate = self;
    
    self.stepMinPriceTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.stepMaxPriceTextField.keyboardType = UIKeyboardTypeNumberPad;
    
    self.priceTextField.keyboardType = UIKeyboardTypeDecimalPad;
    
    [self adjustsFontSizeWithTextField:self.stepMaxPriceTextField];
    
    [self adjustsFontSizeWithTextField:self.stepMinPriceTextField];
    
    [self adjustsFontSizeWithTextField:self.priceTextField];
}

- (void)adjustsFontSizeWithTextField:(UITextField *)textField{
    
    textField.adjustsFontSizeToFitWidth = YES;
    
    textField.minimumFontSize = 1;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    if (textField == self.stepMinPriceTextField) {
        self.changeStepPriceBlock(changeMin);
    }
    
    if (textField == self.stepMaxPriceTextField) {
        
        self.changeStepPriceBlock(changeMax);
    }
    
    if (textField == self.priceTextField) {
        
        self.changeStepPriceBlock(changePrice);
    }
    
    
    
    
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField{
    
    [textField resignFirstResponder];
    
    return YES;
}


- (IBAction)deleteButtonClick:(id)sender {
    
    self.deleteStepPriceBlock();
    
}

- (IBAction)addButtonClick:(id)sender {
    
    self.addStepPriceBlock();
}
@end
