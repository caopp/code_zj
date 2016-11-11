//
//  MoneyConditionEditedTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/5.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "MoneyConditionEditedTableViewCell.h"
#import "Marco.h"
#import "MyShopStateDTO.h"
#import "GetMerchantInfoDTO.h"

@implementation MoneyConditionEditedTableViewCell{
    
    MyShopStateDTO *myShopStateDTO;
    
    GetMerchantInfoDTO *getMerchantInfoDTO;
}

- (void)awakeFromNib {
    // Initialization code
    
    myShopStateDTO = [MyShopStateDTO sharedInstance];
    
    getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    
    NSString *amount = [NSString stringWithFormat:@"%.2lf",[getMerchantInfoDTO.batchAmountLimit floatValue]];
    
    _textField.text = amount;
    
    
    _textField.delegate = self;
    
    _stateOn.on = [getMerchantInfoDTO.batchAmountFlag integerValue]==0?YES:NO;
    
    // !修改混批条件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData) name:kMyShopEditStateChangedNotification object:nil];
    
    //!改变输入框的大小
    [self changeTextFiledFrame:amount];

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData{
    
//    NSLog(@"updateData:%@",_textField.text);
    [self endEditing:YES];
    
    myShopStateDTO = [MyShopStateDTO sharedInstance];
    getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    

    CGFloat num = [_textField.text floatValue];
    
    NSNumber *number = [[NSNumber alloc]initWithFloat:num];
    
    getMerchantInfoDTO.batchAmountLimit = number ;
    getMerchantInfoDTO.batchAmountFlag = _stateOn.on?@"0":@"1";
    

    
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    //!改变输入框的大小
    [self changeTextFiledFrame:textField.text];
    
    NSMutableString * futureString = [NSMutableString stringWithString:textField.text];
    [futureString  insertString:string atIndex:range.location];
    
    NSArray *list = [futureString componentsSeparatedByString:@"."];
    
    if (list.count>2) {
     
        return NO;
    
    }else if (list.count>1){
     
        NSString *decimalStr = [list lastObject];
        if (decimalStr.length>2) {
            return NO;
        }
    
    }

    return YES;
    
}
//!计算输入内容大小，改变textfiled的大小
-(void)changeTextFiledFrame:(NSString *)content{

    CGSize size = [content boundingRectWithSize:CGSizeMake(self.frame.size.width - 215, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;

    
    self.moneyTextFieldWidth.constant = size.width +20;

}

- (void)dealloc{
    
    
    // !修改混批条件
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kMyShopEditStateChangedNotification object:nil];
    
}

@end
