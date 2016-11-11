//
//  CountConditionEditedTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/5.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "CountConditionEditedTableViewCell.h"
#import "Marco.h"
#import "MyShopStateDTO.h"
#import "GetMerchantInfoDTO.h"

@implementation CountConditionEditedTableViewCell{
    
    MyShopStateDTO *myShopStateDTO;
    
    GetMerchantInfoDTO *getMerchantInfoDTO;
}

- (void)awakeFromNib {
    // Initialization code
    myShopStateDTO = [MyShopStateDTO sharedInstance];
    
    getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    
    NSString *num = [NSString stringWithFormat:@"%zi",[getMerchantInfoDTO.batchNumLimit integerValue]];
    _textField.text = num;
    _textField.delegate = self;
    _stateOn.on = [getMerchantInfoDTO.batchNumFlag isEqualToString:@"0"]?YES:NO;

    // !修改混批条件
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(updateData) name:kMyShopEditStateChangedNotification object:nil];
    
    //!改变大小
    [self changeTextFiledFrame:num];
    
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)updateData{
    
    [self endEditing:YES];
    
    getMerchantInfoDTO = [GetMerchantInfoDTO sharedInstance];
    
    float num = [_textField.text floatValue];
    
    NSNumber *number = [[NSNumber alloc]initWithFloat:num];
    
    
   
    // !起批量  如果起批量数量为0 则更改数量
    if (![number integerValue] ) {
        
        getMerchantInfoDTO.batchNumLimit = @0;
//        getMerchantInfoDTO.batchNumFlag = @"1";
        getMerchantInfoDTO.batchNumFlag = _stateOn.on?@"0":@"1";

    }else{
    
        getMerchantInfoDTO.batchNumLimit = number;
        
        getMerchantInfoDTO.batchNumFlag = _stateOn.on?@"0":@"1";
        
    }
    
    
    
    
    
}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{


    //!改变大小
    [self changeTextFiledFrame:textField.text];

    return YES;

}
//!计算输入内容大小，改变textfiled的大小
-(void)changeTextFiledFrame:(NSString *)content{
    
    CGSize size = [content boundingRectWithSize:CGSizeMake(self.frame.size.width - 247, 25) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]} context:nil].size;
    
    
    self.countTextFieldWidth.constant = size.width +20;
    
    
    
}
- (void)dealloc{
    
    // !修改混批条件
    [[NSNotificationCenter defaultCenter]removeObserver:self name:kMyShopEditStateChangedNotification object:nil];
    
}


@end
