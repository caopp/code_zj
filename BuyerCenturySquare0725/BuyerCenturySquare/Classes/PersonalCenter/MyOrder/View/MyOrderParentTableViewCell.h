//
//  MyOrderParentTableViewCell.h
//  BuyerCenturySquare
//
//  Created by 陈光 on 16/3/19.
//  Copyright © 2016年 pactera. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderAllListDTO.h"
#import "OrderDetailDTO.h"

#import "UIImageView+WebCache.h"
@protocol MyOrderParentTableViewDelegate <NSObject>

/**
 *  点击商家名称，进入商家店铺
 */
- (void)MyOrderParentClickMerchantName:(NSString *)merchantNo;

/**
 *  点击客服，询问商家
 */
- (void)MyOrderParentClickCustomerService:(OrderInfoListDTO *)orderInfo;


/**
 *  采购单详情点击客服，询问商家
 */
- (void)MyOrderParentClickCustomerServiceDetail:(OrderDetailDTO *)detailInfo;

/**
 *  取消采购单
 */
- (void)MyOrderParentClickCancelGoodsOrderMemberNo:(NSString *)memberNo orderCode:(NSString *)orderCode;

/**
 *  为采购单付款
 */
- (void)MyOrderParentClickPaymentGoodOrderCodes:(NSString *)orderCode;

/**
 *  延期收货
 */
- (void)MyOrderParentClickDelayGoodsOrderCode:(NSString *)orderCode balanceQuantity:(NSNumber *)balanceQuantity;
/**
 *  合并付款
 */
- (void)MyOrderParentClickTotalPayMentOrderCode:(NSString *)orderCode;

/**
 *  确认收货
 *
 *  @param orderCode
 */
- (void)MyOrderParentClickConfirmOrderCode:(NSString *)orderCode;






@end

@interface MyOrderParentTableViewCell : UITableViewCell<MyOrderParentTableViewDelegate>

@property (nonatomic ,strong)OrderDetailMesssageDTO *orderDetailMessageDto;
@property (nonatomic ,strong)OrderInfoListDTO *orderInfoDto;
@property (nonatomic ,assign) id<MyOrderParentTableViewDelegate>delegate;
@property (nonatomic ,strong) NSString *merchantNo;
@property (nonatomic ,strong) NSString *goodsNo;
@property (nonatomic ,strong) NSString *memberNo;
@property (nonatomic ,strong) NSString *orderCode;
@property (nonatomic ,strong) NSNumber *balanceQuantity;
@property (nonatomic ,assign) NSString *isSelect;


@property (nonatomic ,strong) OrderGoodsItem *goodsItemDto;

/**
 *  采购单详情
 */
@property (nonatomic ,strong) OrderDetailDTO*orderDetailDto;
@property (nonatomic ,strong) NSString *detailMerchantNo;

@property (nonatomic ,strong) NSString *hideLine;




@end

