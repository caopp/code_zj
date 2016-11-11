//
//  ModShopInfoFirstTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ModShopInfoFirstTableViewCell.h"

@implementation ModShopInfoFirstTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _nameL.delegate  = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)manButtonClicked:(id)sender {
    
    [self setIsMan:YES];

}

- (IBAction)womenButtonClicked:(id)sender{
    
    [self setIsMan:NO];
    
}

- (void)setIsMan:(BOOL)isMan{
    
    _isMan = isMan;
    
    if (isMan) {
        
        [_manButton setSelected:YES];
        
        [_womenButton setSelected:NO];
        
    }else{
     
        [_manButton setSelected:NO];
        
        [_womenButton setSelected:YES];
    }
    
    _updateMerchantInfoModel.sex = _isMan?@"1":@"2";
}


- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    _updateMerchantInfoModel.shopkeeper = textField.text;
    
}

@end
