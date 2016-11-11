//
//  DealViewCell.m
//  BuyerCenturySquare
//
//  Created by 张晓旭 on 15/11/19.
//  Copyright © 2015年 pactera. All rights reserved.
//

#import "DealViewCell.h"
#import "UIColor+UIColor.h"
@implementation DealViewCell


//重新设置控件frame的大小
-(void)awakeFromNib
{
    self.digestLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];

    self.createTimeLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    self.orderCodeLabel.textColor = [UIColor colorWithHexValue:0x999999 alpha:1];
    
    
    self.totalamoutLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
    
    self.quantityLabel.textColor = [UIColor colorWithHexValue:0x000000 alpha:1];
}

-(void)settingModelParameters:(DownLoadRecordModel *)parameters
{
    
    //购买时间
    self.createTimeLabel.text = parameters.createTime;
    
    //采购单号
    self.orderCodeLabel.text = [NSString stringWithFormat:@"采购单:%@",parameters.orderCode];
    //购买金额
    self.totalamoutLabel.text = [NSString stringWithFormat:@"¥%.2lf",parameters.totalAmount];

  
    
    //购买单价/次数
    self.digestLabel.text =[NSString stringWithFormat:@"付款次数:%@",parameters.digest];
    
    //购买份数
    self.quantityLabel.text = [NSString stringWithFormat:@"X%d",parameters.quantity];
    
}





@end
