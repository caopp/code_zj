//
//  OrderShowView.m
//  BuyerCenturySquare
//
//  Created by caopenpen on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OrderShowView.h"
#import "DeviceDBHelper.h"
#import "UIImageView+WebCache.h"
@implementation OrderShowView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (IBAction)deleateView:(id)sender {
    [self removeFromSuperview];
}
-(void)awakeFromNib{
    
}
-(void)showOrderWithMessage:(ECMessage *)message{
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
    NSString *goodNum = [dic objectForKey:@"goodNum"];
    NSString *orderNo = [dic objectForKey:@"orderNo"];
    NSString *orderPrice = [dic objectForKey:@"orderPrice"];
    NSString *orderStatus = [dic objectForKey:@"orderStatus"];
    NSArray *arrNum = [goodNum componentsSeparatedByString:@";"];
    _goodNoLabel.text = [NSString stringWithFormat:@"[%@] %@ ￥%@ 采购单号:%@",[[DeviceDBHelper sharedInstance] typeWith:[orderState intValue]],[[DeviceDBHelper sharedInstance] statusWith:[orderStatus intValue] ],orderPrice,orderNo];
    if (arrGoodNo.count >4) {
        _pointLabel.hidden = NO;
    }else{
        _pointLabel.hidden = YES;
    }
    [_OrderImgArray enumerateObjectsUsingBlock:^(OrderImgView* obj, NSUInteger idx, BOOL *stop) {
        
        if (idx<arrGoodNo.count) {
            obj.hidden = NO;
            [obj.imagePic sd_setImageWithURL:[NSURL URLWithString:[arrPic objectAtIndex:idx]]];
            obj.priceLab.text =[NSString stringWithFormat:@"￥%@",[arrPrice objectAtIndex:idx]];
            obj.priceLab.textColor = [UIColor whiteColor];
            obj.goodsCount.text = [NSString stringWithFormat:@"×%@",[arrNum objectAtIndex:idx]];
            obj.goodsCount.textColor = [UIColor whiteColor];
        }else{
            obj.hidden = YES;
        }
        
        
        
    }];
    
    
}

-(void)showOrderWithDic:(NSDictionary *)dicOrder{
    NSArray *arr= [dicOrder objectForKey:@"goodsList"];
    NSString *goodStatus = [dicOrder objectForKey:@"status"];
    NSString *goodOrderCode = [dicOrder objectForKey:@"orderCode"];
    NSString *goodType = [dicOrder objectForKey:@"type"];
    NSString *goodAmount =[dicOrder objectForKey:@"originalTotalAmount"];
    NSNumber *refundStatus = [dicOrder objectForKey:@"refundStatus"];
    NSString *status = [refundStatus isKindOfClass:[NSNumber class]]?[[DeviceDBHelper sharedInstance] refundStatusWith:[refundStatus intValue]]:[[DeviceDBHelper sharedInstance] statusWith:[goodStatus intValue] ];
     _goodNoLabel.text = [NSString stringWithFormat:@"[%@] %@ ￥%@ 采购单号:%@",[[DeviceDBHelper sharedInstance] typeWith:[goodType intValue]],status,goodAmount,goodOrderCode];
    if (arr.count >4) {
        _pointLabel.hidden = NO;
    }else{
        _pointLabel.hidden = YES;
    }
    [_OrderImgArray enumerateObjectsUsingBlock:^(OrderImgView* obj, NSUInteger idx, BOOL *stop) {
        
        if (idx<arr.count) {
            NSDictionary *goodDic = [arr objectAtIndex:idx];
            obj.hidden = NO;
            [obj.imagePic sd_setImageWithURL:[NSURL URLWithString:[goodDic objectForKey:@"picUrl"]]];
            obj.priceLab.text =[NSString stringWithFormat:@"￥%@",[goodDic objectForKey:@"price"]];
            obj.priceLab.textColor = [UIColor whiteColor];
            obj.goodsCount.text = [NSString stringWithFormat:@"×%@",[goodDic objectForKey:@"quantity"]];
            obj.goodsCount.textColor = [UIColor whiteColor];
        }else{
            obj.hidden = YES;
        }
      
 
        
    }];

    
}
@end
