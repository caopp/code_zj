//
//  ModShopDetailInfoTableViewCell.m
//  SellerCenturySquare
//
//  Created by 李春晓 on 15/9/15.
//  Copyright (c) 2015年 pactera. All rights reserved.
//

#import "ModShopDetailInfoTableViewCell.h"
#import "UIColor+HexColor.h"
@implementation ModShopDetailInfoTableViewCell

- (void)awakeFromNib {
    // Initialization code
    _textView.delegate = self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    if ([textView.text isEqualToString:@"商家简介"]) {
        
        
        textView.text = @"";
        textView.textColor = [UIColor blackColor];
    }
}

- (void)textViewDidEndEditing:(UITextView *)textView{
    
    if (textView.text.length==0){
        
        textView.text = @"商家简介";
        textView.textColor = [UIColor colorWithHex:0xAAAAAA alpha:0.75];
        
    }
    
    if ([textView.text isEqualToString:@"商家简介"]) {
        
        _updateMerchantInfoModel.Description = @"";
    }else{
        
        _updateMerchantInfoModel.Description = textView.text;
    }
}

- (void)setDefaultText:(NSString *)defaultText{
    
    _textView.text = defaultText;
    
    if (![_textView.text isEqualToString:@"商家简介"]) {
        
        _textView.textColor = [UIColor blackColor];
    }
}


@end
