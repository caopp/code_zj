//
//  ConnectServiceViewCell.m
//  SellerCenturySquare
//
//  Created by 左键视觉 on 16/3/14.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "ConnectServiceViewCell.h"

@implementation ConnectServiceViewCell

- (void)awakeFromNib {
    // Initialization code

    [self.contentView setBackgroundColor:[UIColor colorWithHex:0xf0f0f0 alpha:1]];

    [self.topFilterLabel setBackgroundColor:[UIColor colorWithHex:0x999999 alpha:1]];
    [self.bottomFilterLabel setBackgroundColor:[UIColor colorWithHex:0x999999 alpha:1]];
    
    self.topFilterLabelHight.constant = 0.5;
    self.bottomFilterLabelHight.constant =  0.5;
    
    
    
    [self.infoLabel setTextColor:[UIColor colorWithHex:0x999999 alpha:1]];
    
    [self.connectBtn setBackgroundColor:[UIColor colorWithHex:0xeb301f alpha:1]];
    [self.connectBtn setTitleColor:[UIColor colorWithHex:0xffffff alpha:1] forState:UIControlStateNormal];

    self.connectBtn.layer.masksToBounds = YES;
    self.connectBtn.layer.cornerRadius = 2;

    

}





- (IBAction)connectBtnClick:(id)sender {
    
    
    if (customAlertView) {
        
        [customAlertView removeFromSuperview];
        
    }
    
    customAlertView = [GUAAlertView alertViewWithTitle:nil withTitleClor:nil message:@"是否拨打客服电话" withMessageColor:nil oKButtonTitle:@"确定" withOkButtonColor:nil cancelButtonTitle:@"取消" withOkCancelColor:nil withView:self buttonTouchedAction:^{
        
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:SERVICEPHONENUMBER]];

        
    } dismissAction:nil];
    
    [customAlertView show];
    
    
    
    
}




- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
