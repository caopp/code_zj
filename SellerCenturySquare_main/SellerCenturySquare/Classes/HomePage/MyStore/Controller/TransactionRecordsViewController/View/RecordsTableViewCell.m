//
//  RecordsTableViewCell.m
//  SellerCenturySquare
//
//  Created by 张晓旭 on 15/11/21.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "RecordsTableViewCell.h"
#import "UIColor+UIColor.h"

@implementation RecordsTableViewCell



- (void)awakeFromNib {
    self.payDownloadLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    
    self.createTimeLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    self.orderCodeLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    
    
    self.moneyLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    
    self.additionalCopiesLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];

    
}

-(void)settingModelParameters:(TransactionRecordsModel *)parameters
{

    //购买时间
    self.createTimeLabel.text = parameters.createTime;
    //采购单号
    self.orderCodeLabel.text = [NSString stringWithFormat:@"采购单:%@",parameters.orderCode];
    //购买单价/次数
    self.payDownloadLabel.text =[NSString stringWithFormat:@"付款次数:%@",parameters.digest] ;
    //购买金额
    self.moneyLabel.text = [NSString stringWithFormat:@"¥%.2f",parameters.totalAmount];
    //购买份数
    self.additionalCopiesLabel.text = [NSString stringWithFormat:@"x%d",parameters.quantity];

}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

@end
