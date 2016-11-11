//
//  OrderDetailHeadView.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/31.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "OrderDetailHeadView.h"
@interface OrderDetailHeadView ()
/**
 *  D订单状态
 */

@property (weak, nonatomic) IBOutlet UIView *showOrderStateView;
//根据内容更改View的宽度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *showOrderStateViewWidth;
//更改顶部的高度
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

/**
 *  付款的状态。代付，代收，，，
 */
@property (weak, nonatomic) IBOutlet UILabel *orderPaymentLab;

/**
 *  所有的采购单的数量
 */
@property (weak, nonatomic) IBOutlet UILabel *goodsNumbLab;
/**
 *  付款金额的状态：应付，实付
// */
//@property (weak, nonatomic) IBOutlet UILabel *paymentStateLab;
//
///**
// *  付款金额
// */
//@property (weak, nonatomic) IBOutlet UILabel *paymentPriceLab;

/**
 *  显示“应付”
 */
//@property (weak, nonatomic) IBOutlet UILabel *payOriginalTitleLab;

/**
 *  应付金额
 */
@property (weak, nonatomic) IBOutlet UILabel *payOriginalPriceLab;


/**
 *  运费价格
 */
//@property (weak, nonatomic) IBOutlet UILabel *freightPriceLab;
/**
 *  采购单状态 期货单，现货单
 */
@property (weak, nonatomic) IBOutlet UILabel *orderStateLab;

/**
 *  采购单号
 */
@property (weak, nonatomic) IBOutlet UILabel *orderNumberLab;

/**
 *  采购单总价
 */
@property (weak, nonatomic) IBOutlet UILabel *orderTotalPriceLab;

/**
 *  收货人
 */
@property (weak, nonatomic) IBOutlet UILabel *shippingNameLab;

/**
 *  收货人电话
 */
@property (weak, nonatomic) IBOutlet UILabel *shippingPhoneLab;

@property (weak, nonatomic) IBOutlet UILabel *courierNameLab;

/**
 *  收货地址
 */
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressLab;
@property (weak, nonatomic) IBOutlet UILabel *shippingAddressContentLab;
//交易的View
@property (weak, nonatomic) IBOutlet UIView *tradingMoneyView;
//交易的金额
@property (weak, nonatomic) IBOutlet UILabel *tradingMoneyLab;

@end
@implementation OrderDetailHeadView
- (void)awakeFromNib
{
    self. showOrderStateView.layer.cornerRadius = 31;
    self.showOrderStateView.layer.masksToBounds = YES;
    self.tradingMoneyView.hidden = YES;
    self.topViewHeight.constant = 160;
    self.payOriginalPriceLab.adjustsFontSizeToFitWidth = YES;
    
    self.tradingMoneyLab.adjustsFontSizeToFitWidth = YES;
    
    
 
}


- (void)setDetailDto:(OrderDetailDTO *)detailDto
{
    if (detailDto) {
        
        
        if (detailDto.freightTemplateName.length>0) {
            self.courierNameLab.text = [NSString stringWithFormat:@"%@",detailDto.freightTemplateName];

        }else
        {
            self.courierNameLab.text = @"包邮";

        }
        
        
        self.payOriginalPriceLab.text = [NSString stringWithFormat:@"%.2f",detailDto.totalAmount];
        //应付：
        
        NSString *payOriginalPriceLab = [NSString stringWithFormat:@"应付: ¥%.2f ",detailDto.totalAmount];
        
        NSMutableAttributedString* priceValueString = [[NSMutableAttributedString alloc]initWithString:payOriginalPriceLab attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];

        
        
        //实付
        
        NSString *payRealLab = [NSString stringWithFormat:@"实付: ¥"];

        NSMutableAttributedString* payRealLabStr = [[NSMutableAttributedString alloc]initWithString:payRealLab attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];
        
        [priceValueString  appendAttributedString:payRealLabStr];
        //应付
        NSString *payShouldLab = [NSString stringWithFormat:@"应付: ¥"];
        

        NSMutableAttributedString* payShouldLabStr = [[NSMutableAttributedString alloc]initWithString:payShouldLab attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];

        NSString *payRealPriceLab = [NSString stringWithFormat:@"%.2lf",detailDto.paidTotalAmount];
        
        NSMutableAttributedString* payRealPriceLabStr = [[NSMutableAttributedString alloc]initWithString:payRealPriceLab attributes:@{NSFontAttributeName: [UIFont fontWithName:@"Tw Cen MT" size:30]}];
        
        [priceValueString appendAttributedString:payRealPriceLabStr];
        
        //运费
        
        NSString *payFreightPriceLab = [NSString stringWithFormat:@"   含运费: ¥ %.2f ",detailDto.dFee.doubleValue];
        
        NSLog(@"payFreightPriceLa = %@",payFreightPriceLab);
        NSMutableAttributedString* payFreightPriceLabStr = [[NSMutableAttributedString alloc]initWithString:payFreightPriceLab attributes:@{NSFontAttributeName: [UIFont systemFontOfSize:14]}];

        
        [priceValueString appendAttributedString:payFreightPriceLabStr];
        
        
        NSLog(@"payFreightPriceLabStr = %@",payFreightPriceLabStr);
        NSLog(@"priceValueString = %@",priceValueString);
        
        
        
        switch (detailDto.status) {
            case 0:
            {
              
                self.orderPaymentLab.text = @"采购单取消";
                [payShouldLabStr appendAttributedString:payRealPriceLabStr];
                [payShouldLabStr appendAttributedString:payFreightPriceLabStr];
                
                self.payOriginalPriceLab.attributedText = payShouldLabStr;
                
            }
                break;
            case 1:
            {
                self.orderPaymentLab.text = @"待付款";
                

                
                [payShouldLabStr appendAttributedString:payRealPriceLabStr];
                [payShouldLabStr appendAttributedString:payFreightPriceLabStr];
                self.payOriginalPriceLab.attributedText = payShouldLabStr;
            }
                break;
            case 2:
            {
                if ([detailDto.refundStatus isKindOfClass:[NSNumber class]]) {
                    
                
                    switch (detailDto.refundStatus.integerValue) {
                        case 0:
                            self.orderPaymentLab.text = @"退货退款_处理中";
                            break;
                            
                        case 1:
                            self.orderPaymentLab.text = @"退货退款_处理完成";
                            break;
                            
                        case 2:
                            self.orderPaymentLab.text = @"仅退款_处理中";
                            break;
                            
                        case 3:
                            self.orderPaymentLab.text = @"仅退款_处理完成";
                            break;
                            
                        case 4:
                            self.orderPaymentLab.text = @"换货_处理中";
                            break;
                            
                        case 5:
                            self.orderPaymentLab.text = @"换货_处理完成";
                            break;
                            
                        case 6:
                            self.orderPaymentLab.text = @"已取消";
                            break;
                            
                            
                        default:
                            break;
                    }
                       self.showOrderStateViewWidth.constant =  [self gainFontWidthContent:self.orderPaymentLab.text];
                    
                    
                    if (detailDto.refundStatus.integerValue == 1||detailDto.refundStatus.integerValue == 3) {
                        
                        
                        
                        self.tradingMoneyLab.text = [NSString stringWithFormat:@"原交易金额:￥%.2f (含运费:￥%.2f) 退款:￥%.2f",detailDto.oldPaidTotalAmount.doubleValue,detailDto.dFee.doubleValue,detailDto.refundFee.doubleValue];
                        self.tradingMoneyView.hidden = NO;
                        self.topViewHeight.constant = 180;
                        [payRealLabStr appendAttributedString:payRealPriceLabStr];
                        
                        self.payOriginalPriceLab.attributedText = payRealLabStr;
                    
                        
                    }else
                    {
                        [payRealLabStr appendAttributedString:payRealPriceLabStr];
                        [payRealLabStr appendAttributedString:payFreightPriceLabStr];

                        self.payOriginalPriceLab.attributedText = payRealLabStr;

                    }
                }
                
                else
                {
                    self.orderPaymentLab.text = @"待发货";
                self.payOriginalPriceLab.attributedText = priceValueString;
                }
                
                


            }
                break;
                
            case 3:

            {
                
                if ([detailDto.refundStatus isKindOfClass:[NSNumber class]]) {
 


                    switch (detailDto.refundStatus.integerValue) {
                        case 0:
                            self.orderPaymentLab.text = @"退货退款_处理中";
                            break;
                            
                        case 1:
                            self.orderPaymentLab.text = @"退货退款_处理完成";
                            break;
                            
                        case 2:
                            self.orderPaymentLab.text = @"仅退款_处理中";
                            break;
                            
                        case 3:
                            self.orderPaymentLab.text = @"仅退款_处理完成";
                            break;
                            
                        case 4:
                            self.orderPaymentLab.text = @"换货_处理中";
                            break;
                            
                        case 5:
                            self.orderPaymentLab.text = @"换货_处理完成";
                            break;
                            
                        case 6:
                            self.orderPaymentLab.text = @"已取消";
                            break;
                            
                            
                        default:
                            break;
                    }
                    self.showOrderStateViewWidth.constant =  [self gainFontWidthContent:self.orderPaymentLab.text];
                    
                    
                    if (detailDto.refundStatus.integerValue == 1||detailDto.refundStatus.integerValue == 3) {
                        
                        
                        
                        self.tradingMoneyLab.text = [NSString stringWithFormat:@"原交易金额:￥%.2f (含运费:￥%.2f) 退款:￥%.2f",detailDto.oldPaidTotalAmount.doubleValue,detailDto.dFee.doubleValue,detailDto.refundFee.doubleValue];
                        self.tradingMoneyView.hidden = NO;
                        self.topViewHeight.constant = 180;
                        [payRealLabStr appendAttributedString:payRealPriceLabStr];
                        self.payOriginalPriceLab.attributedText = payRealLabStr;
                
                    
                    }else
                    {
                        [payRealLabStr appendAttributedString:payRealPriceLabStr];
                        [payRealLabStr appendAttributedString:payFreightPriceLabStr];

                        self.payOriginalPriceLab.attributedText = payRealLabStr;
                    }

                }
                else
                {
                    self.orderPaymentLab.text = @"待收货";
                
                self.payOriginalPriceLab.attributedText = priceValueString;

            }
                

            }
                break;
            case 4:
            {
                self.orderPaymentLab.text = @"交易取消";
                self.payOriginalPriceLab.attributedText = priceValueString;

            }
                break;
                
            case 5:
            {
                self.orderPaymentLab.text = @"交易完成";
                self.payOriginalPriceLab.attributedText = priceValueString;

            }
                break;
                
            default:
                break;
        }

        self.goodsNumbLab.text = [NSString stringWithFormat:@"%ld",(long)detailDto.quantity];
        
        if (detailDto.type== 1) {
                  self.orderStateLab.text = [NSString stringWithFormat:@"现货单"];
            self.orderStateLab.backgroundColor = [UIColor colorWithHexValue:0x09bb07 alpha:1];

            
        }else
        {
            self.orderStateLab.text = [NSString stringWithFormat:@"期货单"];
            self.orderStateLab.backgroundColor = [UIColor colorWithHexValue:0xeb301f alpha:1];

        }
        

        self.orderNumberLab.text = detailDto.orderCode;
        self.orderTotalPriceLab.text = [NSString stringWithFormat:@"%.2f",detailDto.originalTotalAmount];
        
        self.shippingNameLab.text = detailDto.consigneeName;
        self.shippingPhoneLab.text = detailDto.consigneePhone;
        self.shippingAddressContentLab.text = detailDto.detailAddress;
    }
}

/**
 *  计算字体宽度
 *
 *  @param content 输入的内容
 *
 *  @return 返回字体的宽度
 */
- (CGFloat)gainFontWidthContent:(NSString *)content
{
    CGSize size;
    
    size=[content boundingRectWithSize:CGSizeMake(200, 1000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName :[UIFont systemFontOfSize:16]} context:nil].size;
    return size.width;
    
    
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end

