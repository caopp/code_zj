//
//  TopMerchantNameTableViewCell.m
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/21.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import "TopMerchantNameTableViewCell.h"

@interface TopMerchantNameTableViewCell ()

@property (weak, nonatomic) IBOutlet UIButton *selectMerchantBtn;


@end

@implementation TopMerchantNameTableViewCell


/**
 *  选择商家
 *
 *  @param sender
 */
- (IBAction)selelctMerchantClickBtn:(id)sender {
    
}

- (void)awakeFromNib {
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}
/**
 *  点击客服
 *
 *  @param sender
 */
- (IBAction)customerServiceBtn:(id)sender {
// MyOrderParentClickCustomerService
    if ([self.delegate respondsToSelector:@selector(MyOrderParentClickCustomerService:)]) {
        [self.delegate MyOrderParentClickCustomerService:self.orderInfo];
    }
}
- (void)setOrderInfoDto:(OrderInfoListDTO *)orderInfoDto
{
    [super setOrderInfoDto:orderInfoDto];
    
    if (orderInfoDto) {
        self.orderInfo = orderInfoDto;
        [self.merchantNameBtn setTitle:orderInfoDto.merchantName forState:UIControlStateNormal];
        if ( [orderInfoDto.isSelect isEqualToString:@"yes"]) {
            self.selectMerchantNameBtn.selected = YES;
            
        }else
        {
            self.selectMerchantNameBtn.selected = NO;
        }
    }
}


/**
 *  选中要合并的商家
 *
 *  @param sender
 */
- (IBAction)selectMerchantClickBtn:(id)sender {
    
    UIButton *seleBtn = (UIButton *)sender;
    
    seleBtn.selected = !seleBtn.selected;
    if (seleBtn.selected == YES) {
        self.orderInfo.isSelect = @"yes";
        
    }else
    {
        self.orderInfo.isSelect = @"no";
    }

    
    if ([self.delegate respondsToSelector:@selector(MyOrderParentClickTotalPayMentOrderCode:)]) {
        [self.delegate MyOrderParentClickTotalPayMentOrderCode:self.orderCode];
    }
    
}

/**
 *  选中商家名称
 *
 *  @param sender
 */
- (IBAction)selectMerchantNameClickBtn:(id)sender {
    
    if ([self.delegate respondsToSelector:@selector(MyOrderParentClickMerchantName:)]) {
        [self.delegate MyOrderParentClickMerchantName:self.merchantNo];
    }
}
@end

