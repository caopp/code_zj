//
//  ModShopInfoNormalTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/8/11.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ModShopInfoNormalTableViewCell.h"
#import "CSPUtils.h"

@implementation ModShopInfoNormalTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _contentT.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setPicker:(BOOL)set{
    
    if (set) {
     
        self.locatePicker = [[HZAreaPickerView alloc]init];
        
        self.locatePicker.delegate = self;
        
        _contentT.inputView = self.locatePicker;
        
    }else{
        
        _contentT.inputView = nil;
        
    }
    
    
}

- (void)pickerDidChaneStatus:(HZAreaPickerView *)picker{
    
    self.location = picker.locate;
    
    _contentT.text = [NSString stringWithFormat:@"%@ %@ %@", self.location.state, self.location.city, self.location.district];
    _updateMerchantInfoModel.provinceNo = self.location.stateId;
    _updateMerchantInfoModel.cityNo = self.location.cityId;
    _updateMerchantInfoModel.countyNo = self.location.districtId;
    
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    
    switch (_index) {
        case 1:
            
            _updateMerchantInfoModel.mobilePhone = textField.text;
            break;
            
        case 2:
            
            _updateMerchantInfoModel.telephone = textField.text;
            break;
            
        case 3:
        {
            NSString *identify = textField.text;
            
            _updateMerchantInfoModel.identityNo = identify;

            
        }
            break;
        case 4:
            break;
        case 5:
            _updateMerchantInfoModel.detailAddress = textField.text;
            break;
        case 6:
            _updateMerchantInfoModel.contractNo = textField.text;
            break;
        default:
            break;
    }
}

@end
