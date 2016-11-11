//
//  OrderListTableViewCell.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/24.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OrderListTableViewCell.h"
#import "OrderImgView.h"
#import "UIImageView+WebCache.h"
#import "DeviceDBHelper.h"
@implementation OrderListTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
    self.layOutView.backgroundColor = [UIColor whiteColor];
    self.layOutView.wrapContentHeight = YES;  //布局的高度和宽度由子视图决定
    self.layOutView.padding = UIEdgeInsetsMake(5, 5, 5, 5);
    self.layOutView.subviewMargin = 5;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(void)loadMessage:(ECMessage *)message{
    
    self.timeLabel.text = message.showTime? [CSPUtils changeTheDateString:[CSPUtils getTime:message.dateTime]]:@"";
    NSArray *arrGoodNo = [message.goodNo componentsSeparatedByString:@";"];
    NSArray *arrGoodsWillNo =  [message.goodsWillNo componentsSeparatedByString:@";"];
    NSArray *arrPrice =  [message.goodPrice componentsSeparatedByString:@";"];
    NSArray *arrPic =[message.goodPic componentsSeparatedByString:@";"];
    NSData *jsonData = [message.goodSku dataUsingEncoding:NSUTF8StringEncoding];
    NSError *err;
    if (!jsonData) {
         return;
    }
    NSDictionary *dic = [NSJSONSerialization JSONObjectWithData:jsonData
                                                        options:NSJSONReadingMutableContainers
                                                          error:&err];
//
    NSString *orderState = [dic objectForKey:@"orderState"];
    NSNumber *refundStatus = [dic objectForKey:@"refundStatus"];

    NSString *goodNum = [dic objectForKey:@"goodNum"];
    NSString *orderNo = [dic objectForKey:@"orderNo"];
    NSString *orderPrice = [dic objectForKey:@"orderPrice"];
    NSString *orderStatus = [dic objectForKey:@"orderStatus"];
    NSArray *arrNum = [goodNum componentsSeparatedByString:@";"];
    UILabel *titleLab = [UILabel new];
    titleLab.widthDime.equalTo(@(self.frame.size.width));
    titleLab.topPos.equalTo(@(15));
     titleLab.leftPos.equalTo(@(15));
    titleLab.heightDime.equalTo(@(18));
    NSString *status = [refundStatus isKindOfClass:[NSNumber class]]?[[DeviceDBHelper sharedInstance] refundStatusWith:[refundStatus intValue]]:[[DeviceDBHelper sharedInstance] statusWith:[orderStatus intValue] ];
    titleLab.text = [NSString stringWithFormat:@"[%@] %@ ￥%@ 采购单号:%@",[[DeviceDBHelper sharedInstance] typeWith:[orderState intValue]],status,orderPrice,orderNo];
//    titleLab.text = @"[现货单] 待发货 ￥28888.00  采购单号:19929938289199393993";
    
    titleLab.font = [UIFont systemFontOfSize:13.0];
    titleLab.textColor = [UIColor colorWithHexValue:0x666666 alpha:1];
    [self.layOutView addSubview:titleLab];
    
    for (int i =0; i<arrGoodNo.count; i++) {
        OrderImgView *viewOrder = [OrderImgView new];
        viewOrder.widthDime.equalTo(@(60));
        viewOrder.heightDime.equalTo(@(98));
        viewOrder.leftPos.equalTo(@(15));
        viewOrder.topPos.equalTo(@(15));
        [self.layOutView addSubview:viewOrder];
        
        if (i <arrPic.count) {
            [viewOrder.imagePic sd_setImageWithURL:[NSURL URLWithString:[arrPic objectAtIndex:i]]];
        }
        if (i <arrPrice.count) {
            viewOrder.priceLab.text =[NSString stringWithFormat:@"￥%@",[arrPrice objectAtIndex:i]];
        }
        if (i <arrNum.count) {
            viewOrder.goodsCount.text = [NSString stringWithFormat:@"×%@",[arrNum objectAtIndex:i]];
        }
        
    }
}

@end
