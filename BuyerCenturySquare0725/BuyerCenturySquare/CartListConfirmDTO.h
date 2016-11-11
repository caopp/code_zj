//
//  CartListConfirmDTO.h
//  BuyerCenturySquare
//
//  Created by skyxfire on 9/4/15.
//  Copyright (c) 2015 pactera. All rights reserved.
//

#import "BasicDTO.h"
#import "BasicSkuDTO.h"

typedef NS_ENUM(NSUInteger, CartConfirmGoodsType) {
    CartConfirmGoodsTypeOfNormal,
    CartConfirmGoodsTypeOfSample,
    CartConfirmGoodsTypeOfMail,
};

typedef NS_ENUM(NSUInteger, CartConfirmGroupSkuType) {
    CartConfirmGroupSkuTypeOfSpot,
    CartConfirmGroupSkuTypeOfFuture,
};

@interface CartConfirmGoods : BasicDTO

@property (nonatomic, strong)NSString* goodsNo;
@property (nonatomic, strong)NSString* goodsName;
@property (nonatomic, strong)NSString* color;
@property (nonatomic, strong)NSString* pictureUrl;
@property (nonatomic, strong)NSString* cartType;
@property (nonatomic, assign)CGFloat price;
@property (nonatomic, assign)NSInteger quantity;
@property (nonatomic, strong)NSArray* sizes;

- (CartConfirmGoodsType)goodsType;

@end

@interface DelieveryListDTO : BasicDTO
//!模板id
@property (nonatomic ,copy) NSString *templateId;
//!模板名称
@property (nonatomic ,copy) NSString *templateName;
//!运费
@property (nonatomic ,strong) NSNumber *delieveryFee;
//!是否选中
@property (nonatomic ,strong) NSNumber *isSeclect;

@property (nonatomic ,copy) NSString *merchantNo;

@property (nonatomic ,copy) NSString *type;



@end

@interface CartConfirmMerchant : BasicDTO
//! 商家编码
@property (nonatomic, strong)NSString* merchantNo;

//! 商家名称
@property (nonatomic, strong)NSString* merchantName;

//!类型 spot-现货 ;future-期货
@property (nonatomic, strong)NSString* type;
//! 运费
@property (nonatomic ,strong) NSNumber *delieveryFee;
//! 小计 订单金额
@property (nonatomic ,strong) NSNumber *orderTotalPrice;

//! 商品总数
@property (nonatomic ,strong) NSNumber *totalQuantity;

//!运费模板list
@property (nonatomic, strong)NSMutableArray* goodsList;

//! 商品分组
@property (nonatomic ,strong) NSMutableArray *delieveryListArr;




- (CartConfirmGroupSkuType)groupSkuType;

@end

@interface CartListConfirmDTO : BasicDTO

@property (nonatomic, strong) NSString* memberNo;
@property (nonatomic, strong) NSNumber*   totalPrice;
@property (nonatomic, assign) NSInteger totalQuantity;
@property (nonatomic ,strong) NSNumber *totalDelieveryFee;
@property (nonatomic, strong) NSMutableArray* merchantList;


@end
